#!/bin/bash
# Copyright 2011 Nathan Broadbent. All Rights Reserved.
# Released under the LGPL (GNU Lesser General Public License)
#
# Author: nathan.f77@gmail.com (Nathan Broadbent)
#
# Unit tests for git shell scripts

# Setup and tear down
#-----------------------------------------------------------------------------

oneTimeSetUp() {
  thisDir=$PWD

  # Test Config
  git_env_char="e"
  gs_max_changes="20"
  ga_auto_remove="yes"

  # Ensure git is installed
  if ! type git > /dev/null 2>&1; then apt-get install git; fi

  testRepo="/tmp/testRepo"
}

# Silence output from git commands
silentGitCommands() {
  git() { /usr/bin/env git "$@" > /dev/null 2>&1; }
}
# Cancel silent override
verboseGitCommands() {
  unset git
}


setupTestRepo() {
  rm -rf "${testRepo}"
  mkdir -p "$testRepo"
  cd "$testRepo"
  git init > /dev/null
}

oneTimeTearDown() {
  rm -rf "${testRepo}"
}

# Ignore key bindings
function bind() { true; }


# Helpers
#-----------------------------------------------------------------------------

# assert $1 contains $2
assertIncludes() {
  result=1; if echo "$1" | grep -q "$2"; then result=0; fi
  assertTrue "'$1' should have contained '$2'" $result
}

assertNotIncludes() {
  result=1; if echo "$1" | grep -q "$2"; then result=0; fi
  assertFalse "'$1' should not have contained '$2'" $result
}

sed_strip_colors="s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"


# Unit tests
#-----------------------------------------------------------------------------

# Load functions to test
source ../../assets/bashrc/git.sh


test_git_expand_args() {
  local e1="one"; local e2="two"; local e3="three"; local e4="four"; local e5="five"; local e6="six"; local e7="seven"
  local error="Args not expanded correctly"
  assertEquals "$error" "one three seven" "$(git_expand_args 1 3 7)"
  assertEquals "$error" "one two three six" "$(git_expand_args 1..3 6)"
  assertEquals "$error" "seven two three four five one" "$(git_expand_args seven 2..5 1)"
}


test_git_status_with_shortcuts() {
  setupTestRepo

  silentGitCommands

  # Set up some modifications
  touch deleted_file
  git add deleted_file
  git commit -m "Test commit"
  touch new_file
  touch untracked_file
  git add new_file
  echo "changed" > new_file
  rm deleted_file

  verboseGitCommands

  # Test that groups can be filtered by passing a parameter
  status1=$(git_status_with_shortcuts 1)
  status3=$(git_status_with_shortcuts 3)
  status4=$(git_status_with_shortcuts 4)
  # Test for presence of expected groups
  assertIncludes "$status1" "Changes to be committed"
  assertIncludes "$status3" "Changes not staged for commit"
  assertIncludes "$status4" "Untracked files"
  assertNotIncludes "$status3" "Changes to be committed"
  assertNotIncludes "$status4" "Changes not staged for commit"
  assertNotIncludes "$status1" "Untracked files"
  assertNotIncludes "$status4" "Changes to be committed"
  assertNotIncludes "$status1" "Changes not staged for commit"
  assertNotIncludes "$status3" "Untracked files"

  # Run command in current shell, save status into temp file
  temp_file=$(mktemp)
  git_status_with_shortcuts > $temp_file

  # Test output with stripped color codes
  status=$(sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" $temp_file)

  assertIncludes "$status"  "new file: *\[1\] *new_file"       || return
  assertIncludes "$status"   "deleted: *\[2\] *deleted_file"   || return
  assertIncludes "$status"  "modified: *\[3\] *new_file"       || return
  assertIncludes "$status" "untracked: *\[4\] *untracked_file" || return

  # Test that shortcut env variables are set
  local error="Env variable was not set"
  assertEquals "$error" "new_file" "$e1"       || return
  assertEquals "$error" "deleted_file" "$e2"   || return
  assertEquals "$error" "new_file" "$e3"       || return
  assertEquals "$error" "untracked_file" "$e4" || return
}

test_git_status_with_shortcuts_merge_conflicts() {
  setupTestRepo

  silentGitCommands

  # Set up every possible merge conflict
  touch both_modified both_deleted deleted_by_them deleted_by_us
  echo "renamed file needs some content" > renamed_file
  git add both_modified both_deleted renamed_file deleted_by_them deleted_by_us
  git commit -m "First commit"

  git checkout -b conflict_branch
  echo "added by branch" > both_added
  echo "branch line" > both_modified
  echo "deleted by us" > deleted_by_us
  git rm deleted_by_them both_deleted
  git mv renamed_file renamed_file_on_branch
  git add both_added both_modified deleted_by_us
  git commit -m "Branch commit"

  git checkout master
  echo "added by master" > both_added
  echo "master line" > both_modified
  echo "deleted by them" > deleted_by_them
  git rm deleted_by_us both_deleted
  git mv renamed_file renamed_file_on_master
  git add both_added both_modified deleted_by_them
  git commit -m "Master commit"

  git merge conflict_branch

  verboseGitCommands

  # Test output without stripped color codes
  status=$(git_status_with_shortcuts | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
  assertIncludes "$status"      "both added: *\[[0-9]*\] *both_added"             || return
  assertIncludes "$status"   "both modified: *\[[0-9]*\] *both_modified"          || return
  assertIncludes "$status" "deleted by them: *\[[0-9]*\] *deleted_by_them"        || return
  assertIncludes "$status"   "deleted by us: *\[[0-9]*\] *deleted_by_us"          || return
  assertIncludes "$status"    "both deleted: *\[[0-9]*\] *renamed_file"           || return
  assertIncludes "$status"   "added by them: *\[[0-9]*\] *renamed_file_on_branch" || return
  assertIncludes "$status"     "added by us: *\[[0-9]*\] *renamed_file_on_master" || return
}

test_git_status_with_shortcuts_max_changes() {
  setupTestRepo

  local gs_max_changes="5"

  # Add 5 untracked files
  touch a b c d e
  status=$(git_status_with_shortcuts | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
  for i in $(seq 1 5); do
    assertIncludes "$status"  "\[$i\]" || return
  done

  # 6 untracked files is more than $gs_max_changes
  touch f
  status=$(git_status_with_shortcuts | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
  assertNotIncludes "$status"  "\[[0-9]*\]" || return
}


test_git_add_with_shortcuts() {
  setupTestRepo

  touch a b c d e f g h i j
  # Show git status, which sets up env variables
  git_status_with_shortcuts > /dev/null
  git_add_with_shortcuts 2..4 7 8 > /dev/null
  status=$(git_status_with_shortcuts 1 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")

  for c in b c d g h; do
    assertIncludes "$status"  "\[[0-9]*\] $c" || return
  done
}


# load and run shUnit2
[ -n "${ZSH_VERSION:-}" ] && SHUNIT_PARENT=$0
. ../support/shunit2

