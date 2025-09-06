# Repository Guidelines

## Project Structure & Module Organization
- `setup/`: Mac bootstrap scripts (`setup.sh`, `mac_settings.sh`, `packages.sh`, `duti.sh`, `mas.sh`).
- `bashrc/`: Modular shell config loaded via `bashrc/main.sh` (aliases, prompt, path, language toolchains).
- `bin/`: Small utilities and helpers used interactively (e.g., `git-clean-branches`, `dropbox_backup`).
- `docs/`: Install script served at `dotfiles.ndbroadbent.com` (curl-to-install).
- Other: `starship.toml` (prompt), `.shellcheckrc`, `.cspell.json`, `applescript/`, `karabiner-elements/`, `rails_shell/`.

## Build, Test, and Development Commands
- Bootstrap locally: `./setup.sh` — installs tools, applies macOS defaults, sets Bash as shell, and opens key apps. Do not run with sudo.
- Run a single module: `bash setup/mac_settings.sh` or `bash setup/packages.sh`.
- Lint shell scripts: `shellcheck setup/*.sh bashrc/*.sh bin/*` (respects `.shellcheckrc`).
- Spell-check identifiers/docs: `cspell "**/*"` (uses `.cspell.json`).
- Quick syntax check: `bash -n path/to/script.sh`.

## Coding Style & Naming Conventions
- Shell: target Bash, enable strictness (`set -eo pipefail`), prefer POSIX where easy.
- Indentation: 2 spaces; no tabs.
- Filenames: lowercase, hyphenated; executable scripts with `.sh` when run via `bash`.
- Env/paths: reference `"$DOTFILES_PATH"` and quote all variable expansions.
- Output: concise, actionable messages; avoid noisy `set -x` in committed code.

## Testing Guidelines
- Local verification: run target script in isolation first (e.g., `bash setup/duti.sh`).
- Linting is required for changes in `setup/`, `bashrc/`, or `bin/`.
- Manual smoke tests: open a new shell to ensure `bashrc/main.sh` loads without errors; verify expected tools on PATH and prompt shows correctly.
- Risky/macOS-defaults changes: test on a non-primary machine or VM snapshot.

## Commit & Pull Request Guidelines
- Commits: imperative, scoped messages (e.g., `setup: refine Homebrew casks`, `bashrc: fix prompt init`).
- PRs: include summary, rationale, affected scripts, manual test notes (commands run + observed results), and screenshots when UI settings change.
- Keep changes small and reversible; avoid committing machine-specific artifacts.

## Security & Configuration Tips
- Never run `setup.sh` as root; script enforces non-sudo.
- Prefer local clone for development over `curl | bash` from `docs/`.
- Avoid secrets in repo; use `direnv` and private env files instead.
