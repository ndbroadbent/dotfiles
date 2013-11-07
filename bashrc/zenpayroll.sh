#export STE_DRB_URI=druby://localhost:3777
# Add arcanist/bin to PATH
PATH="$PATH:~/code/zenpayroll/arcanist/bin"

LD_LIBRARY_PATH="/usr/local/lib"
#export STE_DRB_URI="druby://localhost:3777"
export STE_DRB_URI="druby://leeroy:3777"
export RUBYLIB=${RUBYLIB}:/Applications/RubyMine.app/rb/testing/patch/bdd:/Applications/RubyMine.app/rb/testing/patch/common

export ZPDEBUG_EDITOR_PATH=x-mine://open?file=/Users/ndbroadbent/code/zenpayroll/zenpayroll/
export ZPDEBUG_ENABLED=1

alias vste="pushd ~/code/zenpayroll; vagrant up; vagrant ssh -c \"\\cd /vagrant/ste && ./bin/ste_drb &\"; popd"

# Reload ZP code (AJAX requests don't reload code)
alias zpr="curl http://zenpayroll.dev:3000 > /dev/null"

export CAPISTRANO_STAGES="staging sandbox production"
