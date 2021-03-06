source 'https://rubygems.org'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'bundler', '~> 1.14', '>= 1.14.5'
gem 'unicorn'

# database
gem 'sqlite3'
gem 'mysql2', '>= 0.3.13', '< 0.5'
gem 'activerecord_any_of', github: 'oelmekki/activerecord_any_of', ref: '22b3bf'
# model
gem 'sequenced', '~> 3.1', '>= 3.1.1'
gem 'kaminari', '~> 0.17.0'
gem 'bootstrap-kaminari-views'
gem 'scoped_search', '~> 3.2', '>= 3.2.2'
gem 'counter_culture', '~> 1.5'
gem 'enumerize', '~> 2.0'
gem 'acts-as-taggable-on', '~> 4.0'
gem 'by_star', '~> 2.2', '>= 2.2.1'
gem 'groupdate', '~> 3.1', '>= 3.1.1'
gem 'chartkick', '~> 2.2', '>= 2.2.1'
gem 'friendly_id', '~> 5.2.0'
gem 'bulk_insert'
gem 'merit'

# geo
gem 'geocoder'

# ui
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.5.1'
gem 'semantic-ui-sass', git: 'https://github.com/doabit/semantic-ui-sass.git'
gem 'haml-rails', '~> 0.9.0'
gem 'redactor2_rails', '~> 0.1.3'
gem 'rails_autolink', '~> 1.1', '>= 1.1.6'
gem 'magnific-popup-rails', '~> 1.1'
gem 'cocoon'
gem 'html_truncator'
gem 'jquery-slick-rails'
gem 'bootstrap3-datetimepicker-rails'
gem 'momentjs-rails'

# assets
source 'https://rails-assets.org' do
  gem 'rails-assets-trianglify'
end

# tool
gem 'axlsx', github: 'randym/axlsx', ref: 'd41258e'
gem 'axlsx_rails', '~> 0.5.0'
gem 'htmlentities', '~> 4.3', '>= 4.3.4'
gem "recaptcha", require: "recaptcha/rails"
gem 'invisible_captcha'
gem 'roo', '~> 2.7', '>= 2.7.1'
gem 'google_drive'
gem 'rest-client', '~> 2.0', '>= 2.0.2'
gem 'streamio-ffmpeg'
gem 'nokogiri', '~> 1.8.1'

# file upload
gem 'carrierwave', '~> 0.10.0'
gem "mini_magick"
gem 'file_validators', '~> 2.0', '>= 2.0.2'
gem "fog"

# auth
gem 'cancancan', '~> 1.10'
gem 'devise', '~> 4.2'
gem 'omniauth', '~> 1.3', '>= 1.3.1'
gem 'omniauth-facebook', '~> 4.0'
gem 'omniauth-twitter', '~> 1.2', '>= 1.2.1'
gem 'omniauth-google-oauth2', '~> 0.3.1'
gem 'omniauth-naver', '~> 0.1.0'
gem 'twitter', '~> 5.16'
gem 'google-api-client', '~> 0.9.2'
gem 'rolify'

# util
gem 'rack-cors'
gem 'rails-i18n'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'dotenv'
gem 'seed-fu', '~> 2.3', '>= 2.3.5'
gem 'bcrypt', '~> 3.1', '>= 3.1.11'
gem 'browser', '~> 2.0', '>= 2.0.2'
gem 'meta-tags', '~> 2.1.0'
gem 'unobtrusive_flash', '~> 3.1'
gem 'ruby_dig', '~> 0.0.2'
gem 'identicon', '~> 0.0.5'
gem 'rails-timeago', '~> 2.15'

# image
gem 'exifr'
gem 'imgkit', '~> 1.6', '>= 1.6.1'
group :development, :test do
  gem 'wkhtmltoimage-binary', '~> 0.12.2'
end
gem 'aws-sdk-s3'

# notification
gem 'postmark-rails', '~> 0.17.0'
gem 'slack-notifier', '~> 1.4'
gem 'exception_notification', '~> 4.1', '>= 4.1.4'
gem 'premailer-rails', '~> 1.9', '>= 1.9.2'
gem 'mjml-rails'

# scheduler
gem 'sidekiq', '~> 4.1'
gem 'sidekiq-cron', '~> 0.4.5'
gem 'sidekiq-unique-jobs', '~> 4.0', '>= 4.0.16'
gem 'redis', '~> 3.2', '>= 3.2.2'
gem 'redis-namespace', '~> 1.5', '>= 1.5.2'

# crawling
gem 'mechanize', '~> 2.7', '>= 2.7.5'
gem 'video_info', '~> 2.6'
gem 'fastimage', '~> 1.9'

# monitor
gem 'newrelic_rpm'
gem 'ey_config'

group :development do
  gem 'web-console', '~> 2.0'
  gem 'puma'
end

group :development, :staging, :test do
  gem 'letter_opener_web'
end

group :development, :test do
  gem 'byebug'
  gem 'minitest-focus',     '~> 1.1', '>= 1.1.2'
  gem 'guard', '~> 2.13.0'
  gem 'guard-minitest',     '~> 2.4.4'
  gem 'timecop', '~> 0.8.0'
  gem 'spring'
  gem 'mocha', '~> 1.1'
  gem 'rails-controller-testing'
  gem 'minitest', '5.10.1'
end

group :test do
  gem 'minitest-rails-capybara'
  gem 'faker'
end
