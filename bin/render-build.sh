#!/usr/bin/env bash
# exit on error
set -o errexit

apt-get update && apt-get install -y libpq-dev
bundle install
bundle exec rails assets:precompile
# 以下追加
bundle exec rake assets:clean
bundle exec rails db:migrate