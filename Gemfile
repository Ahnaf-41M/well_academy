source "https://rubygems.org"

ruby file: ".ruby-version"

gem "bcrypt", "~> 3.1.7"
gem "benchmark"
gem "bootsnap", require: false
gem "cancancan", "~> 3.3"
gem "importmap-rails"
gem "rails-controller-testing"
gem "rails-i18n"
gem "jbuilder"
gem "ostruct"
gem "pg", "~> 1.1"
gem "pry"
gem "puma", ">= 5.0"
# Pinned to >= 7.2.3.2: CVE-2026-66066 (Active Storage arbitrary file read + RCE
# in variant processing) is only fixed in 7.2.3.2; 7.2.3.1 is insufficient. The
# same bump also clears the actionpack/actionview/activerecord/activesupport/
# activestorage advisories fixed across 7.2.2.1 through 7.2.3.1.
gem "rails", "~> 7.2.3", ">= 7.2.3.2"
gem "rufus-scheduler"
gem "sidekiq"
gem "sidekiq-cron" # Optional for scheduling jobs
gem "sprockets-rails"
gem "stimulus-rails"
gem "streamio-ffmpeg"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mswin mingw x64_mingw jruby ]
gem "webpacker"
gem "kaminari"

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "letter_opener"
  gem "letter_opener_web"
  gem "rspec-rails", "~> 6.0"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "bullet"
  gem "web-console"
end
