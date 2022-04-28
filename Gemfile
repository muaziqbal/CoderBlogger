source 'https://rubygems.org'
ruby "2.2.4"

gem 'active_model_serializers'
gem 'bcrypt', '~> 3.1.7'
gem 'browser'
gem 'bugsnag'
gem 'capybara'
gem 'carrierwave_backgrounder'
gem 'carrierwave-aws'
gem 'clearance'
gem 'coffee-rails', '~> 4.1.0'
gem 'connection_pool'
gem 'dalli'
gem 'excon'
gem 'faraday'
gem 'friendly_id'
gem 'green_monkey'
gem 'haml-rails'
gem 'icalendar'
gem 'invisible_captcha'
gem 'jbuilder'
gem 'kaminari'
gem 'lograge'
gem 'meta-tags'
gem 'mini_magick'
gem 'mini_racer'
gem 'pg', '~> 0.15'
gem 'poltergeist'
gem 'postmark-rails'
gem 'puma_worker_killer'
gem 'puma'
gem 'pusher'
gem 'quiet_assets'
gem 'rack-cors'
gem 'rack-mini-profiler', require: false
gem 'rack-ssl-enforcer'
gem 'rack-timeout'
gem 'rails_stdout_logging', group: [:development, :production]
gem 'rails', '~> 4.2.5'
gem 'react_on_rails'
gem 'redcarpet', ">=3.3.4"
gem 'sass-rails', '~> 5.0'
gem 'stripe'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'letsencrypt_plugin'

# Legacy gems needed for porting, can remove soon
gem 'sequel'
gem 'redis'
gem 'reverse_markdown'
# gem 'newrelic_rpm'

group :development, :test do
  gem 'dotenv-rails'
  gem 'fabrication-rails'
  gem 'faker'
  gem 'google_drive'
  gem 'letter_opener'
  gem 'rubocop', require: false
  gem 'traceroute'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'shoulda'
  gem 'timecop'
end

group :development do
  gem 'spring'
  gem 'web-console', '~> 2.0'
end

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end
