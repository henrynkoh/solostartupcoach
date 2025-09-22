source 'https://rubygems.org'
ruby '3.2.2'

# Core Rails gems
gem 'bootsnap', require: false
gem 'puma'
gem 'rails', '~> 8.0'
gem 'sqlite3'

# Background job processing
gem 'sidekiq'
gem 'sidekiq-scheduler'

# API and web scraping
gem 'google-apis-youtube_v3'
gem 'httparty'
gem 'nokogiri'

# Environment variables and configuration
gem 'dotenv-rails'

# Frontend
gem 'importmap-rails'
gem 'jbuilder'
gem 'stimulus-rails'
gem 'turbo-rails'

# JavaScript and UI
gem 'actiontext'
gem 'chartkick'
gem 'groupdate'
gem 'image_processing'

# Development tools
group :development do
  gem 'debug'
  gem 'web-console'
  
  # Documentation
  gem 'yard'
end

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
# gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
# gem "propshaft"
# Use sqlite3 as the database for Active Record
# gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
# gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
# gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
# gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
# gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache and Active Job
# gem "solid_cache"
# gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
# gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
# gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
# gem "thruster", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  # gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Ruby style checking and code analyzer
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

# Security
gem 'bcrypt'
gem 'devise'
gem 'devise-security'
gem 'devise-two-factor'
gem 'rack-attack'
gem 'secure_headers'

# Cache and Background Jobs
gem 'connection_pool'
gem 'hiredis'
gem 'redis', '>= 4.0.1'

group :test do
  gem 'capybara'
  gem 'webdrivers'
end
