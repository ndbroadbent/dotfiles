#export STE_DRB_URI=druby://localhost:3777
# Add arcanist/bin to PATH
PATH="$PATH:~/code/zenpayroll/arcanist/bin"

LD_LIBRARY_PATH="/usr/local/lib"
export STE_DRB_URI="druby://localhost:3777"
#export STE_DRB_URI="druby://leeroy:3777"
export RUBYLIB=${RUBYLIB}:/Applications/RubyMine.app/rb/testing/patch/bdd:/Applications/RubyMine.app/rb/testing/patch/common

export ZPDEBUG_EDITOR_PATH=x-mine://open?file=/Users/ndbroadbent/code/zenpayroll/zenpayroll/
export ZPDEBUG_ENABLED=1

export ZPDEBUG_LIVE_EDIT=1
export ZPDEBUG_LIVE_EDIT_PORT=1337

alias vste="pushd ~/code/zenpayroll; vagrant up; vagrant ssh -c \"\\cd /vagrant/ste && ./bin/ste_drb &\"; popd"

# Reload ZP code (AJAX requests don't reload code)
alias zpr="curl http://zenpayroll.dev:3000 > /dev/null"

alias z="cd ~/code/zenpayroll/zenpayroll"
alias zs="cd ~/code/zenpayroll/zensa"

export CAPISTRANO_STAGES="staging sandbox production"

setup_leeroy_tunnel() {
  while true; do
    ssh -L 3777:localhost:3777 -N leeroy
    echo 'Connection lost, retrying... (press Ctrl-C to quit)'
    sleep 2
  done
}
