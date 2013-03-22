DATABASE_BRANCHES_FILE=".database_branches~"
DATABASE_USER="root"

add_branched_db() {
  database=$(rails_database development database)
  branch=$(parse_git_branch)
  branched_db="${database}_${branch}"

  # Copy original database to new database
  if [ $(rails_database development adapter) = 'mysql2' ]; then
    mysql -u $DATABASE_USER -e "CREATE DATABASE IF NOT EXISTS $branched_db;"
    mysqldump -u $DATABASE_USER "$database" | mysql -u $DATABASE_USER "$branched_db"
    echo "Copied '$database' to '$branched_db'."
  fi

  # Add entry to branch index, so that DB_SUFFIX is exported when switching branches
  _rm_db_branch_entry "$branch"
  echo "$branch" >> $DATABASE_BRANCHES_FILE
  echo "Added database branches entry for '$branch' branch."
}

rm_branched_db() {
  database=$(rails_database development database)
  branch=$(parse_git_branch)
  branched_db="${database}_${branch}"

  # Drop branched database
  if [ $(rails_database development adapter) = 'mysql2' ]; then
    mysql -u $DATABASE_USER -e "DROP DATABASE IF EXISTS $branched_db;"
    echo "Dropped '$branched_db' database."
  fi
  _rm_db_branch_entry "$branch"
  echo "Deleted database branches entry for '$branch' branch."
}

_rm_db_branch_entry() {
  # Remove entry from branch index
  if [ -e $DATABASE_BRANCHES_FILE ]; then
    sed "/^$1/d" -i $DATABASE_BRANCHES_FILE
  fi
}

reset_branched_db() {
  rm_branched_db
  add_branched_db
}

# Checks branch, and exports DB_SUFFIX if there's a corresponding entry in DATABASE_BRANCHES_FILE
set_db_name_for_branch() {
  if [ -e $DATABASE_BRANCHES_FILE ]; then
    branch=$(parse_git_branch)
    if grep -q "^$branch" $DATABASE_BRANCHES_FILE; then
      export DB_SUFFIX="_$branch"
      return
    fi
  fi
  unset DB_SUFFIX
}

# Add branch check to prompt command
autoreload_prompt_command+="set_db_name_for_branch;"