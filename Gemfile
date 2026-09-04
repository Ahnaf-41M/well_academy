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
# Floor pinned at 8.0.5.1: CVE-2026-66066 (CVSS 9.5, arbitrary file read / RCE
# in Active Storage variant processing). Also carries the Mar 2026 batch
# (CVE-2026-33658 Active Storage Range DoS et al.) and CVE-2025-24293 /
# CVE-2025-55193 from 8.0.2.1.
gem "rails", "~> 8.0.0", ">= 8.0.5.1"
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
  gem "rspec-rails", "~> 8.0"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "bullet"
  gem "web-console"
end
