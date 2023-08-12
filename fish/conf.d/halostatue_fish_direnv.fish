status is-interactive || exit

if command -sq direnv && not functions -q __direnv_export_eval
    direnv hook fish | source
end

function _halostatue_fish_direnv_uninstall -e halostatue_fish_direnv_uninstall
    functions -e (functions -a | command awk '/^__direnv/') (status function)
end
