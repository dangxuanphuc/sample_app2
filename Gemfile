source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.6.1"

gem "bcrypt", "3.1.12"
gem "bootstrap-kaminari-views"
gem "bootstrap-sass", "3.4.1"
gem "carrierwave", "1.2.2"
gem "coffee-rails", "~> 4.2"
gem "config"
gem 'daemons'
gem 'delayed_job_active_record'
gem "devise"
gem "faker", "1.7.3"
gem "figaro"
gem "font-awesome-sass", "~> 5.6.1"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "kaminari"
gem "mini_magick", "4.7.0"
gem "puma", "~> 3.11"
gem "rails", "~> 5.2.1"
gem "sass-rails", "~> 5.0"
gem "sidekiq"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"

gem "bootsnap", ">= 1.1.0", require: false
gem "rubocop", "~> 0.54.0", require: false

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "bullet"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "sqlite3", "~> 1.3.6"
  gem "web-console", ">= 3.3.0"
  gem "pry"
end

group :production do
  gem "fog"
  gem "pg", "0.20.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
