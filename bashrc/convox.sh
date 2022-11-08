alias cx="convox"

# alias cxs="echo formapi > ~/code/docspring/.convox/app \
#   && cp ~/.convox/host.staging ~/.convox/host \
#   && rm -f ~/.convox/rack \
#   && printf 'Switched to Staging host: ' \
#   && cat ~/.convox/host"
alias cxp="convox switch production-v3"
alias cxeu="convox switch europe-v3"

alias cxr="convox rack"
alias cxe="convox exec"
alias cxru="convox run"
alias cxd="convox deploy --wait"
alias cxl="convox logs"
alias cxrs="convox resources"
alias cxsc="convox scale"
alias cxi="convox instances"
alias cxrl="convox releases"
alias cxb="convox builds"
alias cxps="convox ps"

# Easy way to switch between versions.
# Install v3: https://docs.convox.com/installation/cli
# Install v2: https://github.com/convox/docs/blob/8b3dfeef207711d442295afdb08c88491b0869a4/docs/introduction/installation.md
# See also: https://community.convox.com/t/what-happened-to-gen-2-cli-downloads/741
# https://docsv2.convox.com/introduction/installation
# Upgrading: https://docs.convox.com/help/upgrading
# alias convox2="set -x && sudo ln -fs /usr/local/bin/convox2 /usr/local/bin/convox && set +x"
# alias convox3="set -x && sudo ln -fs /usr/local/bin/convox3 /usr/local/bin/convox && set +x"

alias cx2="convox2"
alias cx3="convox3"
