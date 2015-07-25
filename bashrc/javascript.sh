gulp() {
  if [ -e "./node_modules/.bin/gulp" ]; then
    "./node_modules/.bin/gulp" "$@";
  else
    if type /usr/local/bin/gulp > /dev/null 2>&1; then
      /usr/local/bin/gulp "$@";
    else
      echo "gulp not found.";
    fi;
  fi
}
