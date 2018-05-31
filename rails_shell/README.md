# Rails Shell

Aliases, functions and tab completion for Rails development, extracted from my [dotfiles](https://github.com/ndbroadbent/dotfiles).

### Only Bash for now, ZSH support soon.

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


## Aliases

### Rails

*Rails aliases work with any version of Rails.*

| Alias         | Command |
| ------------: | :------------- |
| rs | rails server --binding=127.0.0.1 |
| rs\<1-9> | rails server --binding=127.0.0. -p 300*   (`rs1` => `-p 3001`) |
| rc | rails console |
| rg | rails generate |
| rsd | rails server -u (debug) |
| rdb | rails dbconsole |
| ru | rails runner |

We always start the Rails server bound to 127.0.0.1, so that your app cannot be accessed from anyone on your network.
Otherwise, this can be a big security risk.

### Rake

| Alias         | Command |
| ------------: | :------------- |
| r | rake |
| rdm | rake db:migrate |
| rdu | rake db:migrate:up |
| rdd | rake db:migrate:down |
| rdr | rake db:rollback |
| rdc | rake db:create |
| rdp | rake db:drop |
| rdtp | rake db:test:prepare |
| rsp | rake spec |
| rts | rake test |
| rps | rake parallel:spec |
| rpl | rake parallel:load_schema |
| rpls | rake parallel:load_schema parallel:spec |

The `parallel:` aliases are for the [parallel_tests](https://github.com/grosser/parallel_tests) gem.

### Bundler / Rubygems

| Alias         | Command |
| ------------: | :------------- |
| b | bundle  (which runs `bundle install` by default) |
| bi | bundle install |
| bu | bundle update |
| be | bundle exec |
| bl | bundle list |
| bp | bundle package |
| bo | bundle open |
| gmi | gem install |
| gml | gem list |
| gmb | gem build |
| gmd | cd $GEM_HOME/gems |

You'll need to install bundler 1.4.0 or later, which supports parallel installation.
Run: `gem install bundler --pre`

### RVM

| Alias         | Command |
| ------------: | :------------- |
| rvmi | rvm install |
| rvml | rvm list |
| rvmgl | rvm gemset list |
| rd | rvm use default |
| r2 | rvm use 2.0.0 |
| r\<xxx> | rvm use *x.x.x* |
| rjr | rvm use jruby |

### Capistrano

| Alias         | Command |
| ------------: | :------------- |
| cdp | cap deploy |
| cpd | cap production deploy |
| cpdm | cap production deploy:migrations |
| pcpd | git push; cap production deploy |
| c\<s>d | cap \<stage> deploy |
| c\<s>dm | cap \<stage> deploy:migrations |
| pc\<s>d | git push; cap \<stage> deploy |

If you define a `$CAPISTANO_STAGES` variable before you load Rails Shell, then
cap aliases will be automatically defined using a unique character for each stage.
The default stages are **staging** and **production**.

For example, if you set `CAPISTRANO_STAGES="cow chicken chipmunk"`, you'll get the following aliases:

| Alias | Command |
| ---: | :---- |
| ccd | cap cow deploy |
| chd | cap chicken deploy |
| cid | cap chipmunk deploy |

### Vagrant

| Alias         | Command |
| ------------: | :------------- |
| vu | vagrant up |
| vs | vagrant ssh |
| vr | vagrant reload |
| vh | vagrant halt |

# Thanks

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) - Shares some of the same aliases and functions
* [rails_completion](https://github.com/jweslley/rails_completion) - Bash completion for Rails commands

# Contributing

Please feel free to fork and submit a pull request with your favorite aliases and command-line tricks.
