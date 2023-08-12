complete --erase --command direnv

set -l file_commands allow permit grant block deny revoke edit
set -l commands $file_commands exec fetchurl help hook prune reload status stdlib version

complete --command direnv --description "unclutter your .profile" --no-files

complete --command direnv --condition __fish_use_subcommand \
    --arguments allow \
    --description "Grants direnv permission to load the given .envrc or .env file."

complete --command direnv --condition __fish_use_subcommand \
    --arguments permit \
    --description "Grants direnv permission to load the given .envrc or .env file."

complete --command direnv --condition __fish_use_subcommand \
    --arguments grant \
    --description "Grants direnv permission to load the given .envrc or .env file."

complete --command direnv --condition __fish_use_subcommand \
    --arguments block \
    --description "Revokes the authorization of a given .envrc or .env file."

complete --command direnv --condition __fish_use_subcommand \
    --arguments deny \
    --description "Revokes the authorization of a given .envrc or .env file."

complete --command direnv --condition __fish_use_subcommand \
    --arguments revoke \
    --description "Revokes the authorization of a given .envrc or .env file."

complete --command direnv --condition __fish_use_subcommand \
    --arguments edit \
    --description "Opens PATH_TO_RC or the current .envrc or .env into an $EDITOR and allow the file to be loaded afterwards."

complete --command direnv --condition "__fish_seen_subcommand_from $file_commands" \
    --force-files

complete --command direnv --condition __fish_use_subcommand \
    --arguments exec \
    --description "Executes a command after loading the first .envrc or .env found in DIR"

complete --command direnv --condition "__fish_seen_subcommand_from exec" \
    --arguments "(__fish_complete_directories)" \
    --description "The directory in which to execute COMMAND"

complete --command direnv --condition __fish_use_subcommand \
    --arguments fetchurl \
    --description "Fetches a given URL into direnv's CAS"

complete --command direnv --condition __fish_use_subcommand \
    --arguments help \
    --description "Shows help for direnv"

complete --command direnv --condition __fish_use_subcommand \
    --arguments hook \
    --description "Used to setup the shell hook"

complete --command direnv --condition "__fish_seen_subcommand_from hook" \
    --arguments "bash zsh fish tcsh elvish"

complete --command direnv --condition __fish_use_subcommand \
    --arguments prune \
    --description "removes old allowed files"


complete --command direnv --condition __fish_use_subcommand \
    --arguments reload \
    --description "triggers an env reload"

complete --command direnv --condition __fish_use_subcommand \
    --arguments status \
    --description "prints some debug status information"

complete --command direnv --condition __fish_use_subcommand \
    --arguments stdlib \
    --description "Displays the stdlib available in the .envrc execution context"

complete --command direnv --condition __fish_use_subcommand \
    --arguments version \
    --description "prints the version or checks that direnv is older than VERSION_AT_LEAST"
