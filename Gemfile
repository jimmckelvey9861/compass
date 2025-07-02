# Primary source is Square's gem proxy
source "https://gems.vip.global.square" do
  # Core dependencies
  gem "rails", "~> 7.0.0"  # More stable version
  gem "pg", "~> 1.1"
  gem "puma", "~> 5.0"
  gem "sprockets-rails"
  gem "importmap-rails"
  gem "turbo-rails"
  gem "stimulus-rails"
  gem "tailwindcss-rails"
  gem "jbuilder"
  gem "aws-sdk-s3", require: false
  gem "image_processing", "~> 1.2"
  gem "redis", "~> 4.0"
  gem "bootsnap", require: false
  gem "tzinfo-data"
  gem "logger", "~> 1.7.0"
  gem "browser"
  gem 'foreman', require: false
  # gem 'faker'
  
  group :development, :test do
    gem "debug"
    gem "rspec-rails"
    gem "factory_bot_rails"
  end

  group :development do
    gem "web-console"
  end

  group :test do
    gem "capybara"
    gem "selenium-webdriver"
  end
end

ruby "3.2.2"  # More stable version