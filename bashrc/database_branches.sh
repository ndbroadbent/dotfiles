DATABASE_BRANCHES_FILE=".database_branches~"
DATABASE_USER="root"

# Commands
# --------------------------------------------------------------------------------

branch_db(){
  local branch="$(parse_git_branch)"
  local environment
  for environment in development test; do
    _clone_db "$branch" "$environment"
  done

  # Add entry to branch index, so that DB_SUFFIX is exported when switching branches
  _rm_db_branch_entry "$branch"
  echo "$branch" >> $DATABASE_BRANCHES_FILE
  echo "Added database branches entry for '$branch' branch."
}

rm_db() {
  local branch="$(parse_git_branch)"
  local environment
  for environment in development test; do
    _drop_db "$branch" "$environment"
  done

  _rm_db_branch_entry "$branch"
  echo "Deleted database branches entry for '$branch' branch."
}

reset_db() {
  rm_db
  branch_db
}

rm_all_dbs() {
  local branch
  local environment
  for branch in $(cat $DATABASE_BRANCHES_FILE); do
    for environment in development test; do
      _drop_db "$branch" "$environment"
    done

    _rm_db_branch_entry "$branch"
    echo "Deleted database branches entry for '$branch' branch."
  done
}

# Clones branched test database for running tests in parallel
reset_test_dbs() {
  local branch="$(parse_git_branch)"
  local database="$(rails_database test database)"
  local branched_db="${database}_${branch}"

  for i in 1 2 3; do
    local test_db="$database$i"
    mysql -u $DATABASE_USER -e "DROP DATABASE IF EXISTS $test_db;"
    mysql -u $DATABASE_USER -e "CREATE DATABASE IF NOT EXISTS $test_db;"
    mysqldump -u $DATABASE_USER "$branched_db" | mysql -u $DATABASE_USER "$test_db"

    echo "Reset '$test_db' for '$branch' branch."
  done
}


# Functions
# --------------------------------------------------------------------------------

_clone_db() {
  local branch="$1"
  local environment="$2"
  local database="$(rails_database $environment database)"
  local branched_db="${database}_${branch}"

  # Copy original database to new database
  if [ $(rails_database $environment adapter) = 'mysql2' ]; then
    mysql -u $DATABASE_USER -e "CREATE DATABASE IF NOT EXISTS $branched_db;"
    mysqldump -u $DATABASE_USER "$database" | mysql -u $DATABASE_USER "$branched_db"
    echo "Copied '$database' to '$branched_db'."
  fi
}

_drop_db() {
  local branch="$1"
  local environment="$2"
  local database="$(rails_database $environment database)"
  local branched_db="${database}_${branch}"

  # Drop branched database
  if [ $(rails_database $environment adapter) = 'mysql2' ]; then
    mysql -u $DATABASE_USER -e "DROP DATABASE IF EXISTS $branched_db;"
    echo "Dropped '$branched_db' database."
  fi
}

_rm_db_branch_entry() {
  # Remove entry from branch index
  if [ -e $DATABASE_BRANCHES_FILE ]; then
    sed "/^$1/d" -i $DATABASE_BRANCHES_FILE
  fi
}


# Prompt
# --------------------------------------------------------------------------------

# Checks branch, and exports DB_SUFFIX if there's a corresponding entry in DATABASE_BRANCHES_FILE
set_db_name_for_branch() {
  if [ -e $DATABASE_BRANCHES_FILE ]; then
    local branch=$(parse_git_branch)
    if grep -q "^$branch" $DATABASE_BRANCHES_FILE; then
      export DB_SUFFIX="_$branch"
      return
    fi
  fi
  unset DB_SUFFIX
}

# Add branch check to prompt command
autoreload_prompt_command+="set_db_name_for_branch;"