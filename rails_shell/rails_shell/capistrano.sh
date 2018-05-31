# Capistrano aliases for each stage
if [ -z "$CAPISTRANO_STAGES" ]; then
  CAPISTRANO_STAGES="staging production"
fi

_unique_chr_for_stage() {
  local chr; local i=1
  while [[ -z "$chr" || "$2" = *"$chr"* ]] ; do
    chr=$(echo $1 | head -c $i | tail -c 1)
    let i++
    if [ $i -gt ${#stage} ]; then return; fi
  done
  printf "$chr"
}

_used_chars=""
for stage in $CAPISTRANO_STAGES; do
  chr=$(_unique_chr_for_stage "$stage" "$_used_chars")

  if [ -z "$chr" ]; then
    echo "Could not find a unique chracter for stage: $stage"

  else
    _used_chars="$_used_chars$chr"

    alias  c$chr\d="cap $stage deploy"
    alias c$chr\dm="cap $stage deploy:migrations"
    # Push, then deploy
    alias pc$chr\d="git push; cap $stage deploy"
    # Shortcuts for https://github.com/ndbroadbent/capistrano_deploy_lock
    alias  c$chr\l="cap $stage deploy:lock"
    alias  c$chr\u="cap $stage deploy:unlock"

    alias  c$chr\r="cap $stage deploy:revisions"
  fi
done

alias cdp='cap deploy'

unset _used_chars
