#
# Update and deploy Crossroads branch.
alias update_cr="git checkout crossroads; git merge master; git push; cap deploy; git checkout master"
# Update the live branch to the master revision.
alias rebase_live='git checkout live && git rebase master && git checkout master'

# Restart Atlassian Bamboo server
restart_bamboo() {
  bamboo_server="root@integration.crossroadsint.org"
  echo "=== Restarting Bamboo server at: $bamboo_server ..."
  ssh root@integration.crossroadsint.org "/etc/init.d/bamboo restart"
  echo "===== Restarted. Bamboo agents will automatically restart."
}

