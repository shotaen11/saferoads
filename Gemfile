source "https://rubygems.org"

ruby "3.1.2"

gem "rails", "~> 7.1.5.1"

gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem "debug", platforms: %i[ mri mingw ]
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

group :production do
  gem "pg"
end

gem "refile", require: "refile/rails", github: 'manfe/refile'
gem "refile-mini_magick"
gem 'ffi'

gem 'bootstrap', '~> 5.3.0'
gem 'jquery-rails'
gem "sassc-rails"
gem 'devise'
gem 'kaminari'
gem 'enum_help'
gem 'devise-i18n'
gem 'cssbundling-rails'
gem 'dartsass-rails'
