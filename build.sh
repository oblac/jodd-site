rm Gemfile.lock
gem install -v 1.10.6 bundler --no-rdoc --no-ri
bundle _1.10.6_ install
bundler exec nanoc compile
