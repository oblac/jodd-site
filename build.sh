#!/usr/bin/env bash

rm Gemfile.lock
bundle install --path vendor/cache --without development
bundler exec nanoc compile
