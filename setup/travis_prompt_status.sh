curl -sL https://raw.github.com/gist/1708408/travis.rb > ~/bin/travis-ci \
  && chmod +x ~/bin/travis-ci

gem install hub | tail -2
ruby -e 'require "json"' 2>/dev/null || gem install json
