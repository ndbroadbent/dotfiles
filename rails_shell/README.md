# Rails Shell

Aliases, functions and tab completion for Rails development.

### Only Bash for now, ZSH support ~soon~ maybe later. Or never.

You might also be interested in [SCM Breeze](https://github.com/ndbroadbent/scm_breeze), which provides aliases and shortcuts for git.

# Installation

```bash
git clone https://github.com/ndbroadbent/rails_shell ~/.rails_shell && ~/.rails_shell/install.sh
```

This will add a line to your `~/.bashrc` to load Rails Shell.
It will also add a scheduled task to update cached tab completions.

## Tab Completion

Rails Shell includes bash tab completion for rake tasks, cap tasks, and rails generators. (Thanks to [@jweslley](https://github.com/jweslley) for the [rails tab completions](https://github.com/jweslley/rails_completion).)
A scheduled task caches tab completions for each of your Rails repos.

See the [rails_completion README](https://github.com/jweslley/rails_completion/#rails-completion) for details about Rails tab completions.

### How to configure your list of Rails repos:

#### Basic (works by default)

  * Create a file at `~/.rails_repos`, where each line is an absolute path to a Rails repo.
  * The scheduled task will run every hour to update cached tab completions for each of these repos.
  * To update tab completions manually, cd to your Rails directory and run: `cache_rails_tab_completions`

#### Use SCM Breeze's [Repository Index](https://github.com/ndbroadbent/scm_breeze#repository-index)

  * Install SCM Breeze from https://github.com/ndbroadbent/scm_breeze
  * After installing, re-run `~/.rails_shell/install.sh`, and the scheduled task will be updated to use the repository index from SCM Breeze.

## Bundler

### Auto `bundle exec`

All gem commands (*rails*, *rake*, *rspec*, etc.) are wrapped with `bundle exec`, so you'll never need to type it.

### Auto `bundle install` on `GemNotFound` error

If you run a command that fails because bundler can't find a gem,
`bundle install` will automatically run, and the command will be retried. You'll also never need to type `bundle install`.

# Thanks

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) - Shares some of the same aliases and functions
* [rails_completion](https://github.com/jweslley/rails_completion) - Bash completion for Rails commands

# Contributing

Please feel free to fork and submit a pull request with your favorite aliases and command-line tricks.
