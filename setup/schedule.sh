#!/bin/bash
if [ "$(basename $(pwd))" = "setup" ]; then . _shared.sh; else . setup/_shared.sh; fi;

# Install whenever
if ! gem list whenever | grep --color=auto -q whenever; then
  gem install whenever;
fi

whenever -f schedule.rb -w