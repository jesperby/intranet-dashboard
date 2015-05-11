source 'https://rubygems.org'

gem 'protected_attributes'

gem 'rails', '4.2.1'
gem 'jquery-rails', '4.0.3'
gem 'haml', '4.0.6'

gem 'sass-rails', '5.0.3'
gem 'coffee-rails', '4.1.0'
gem 'uglifier', '2.7.1'

gem 'nokogiri', '1.6.6.2'
gem 'feedjira', '1.6.0'
gem 'savon', '2.11.0'
gem 'siteseeker_normalizer', '0.1.4'

gem 'net-ldap', '0.3.1' # '0.3.1' works, 0.5 and 0.6 (0.10.1?) have an encoding issue: https://github.com/ruby-ldap/ruby-net-ldap/pull/82
gem 'ruby-saml', '0.7.0' # 0.7.1/2 is broken
gem 'bcrypt-ruby', '3.1.5'

gem 'dalli', '2.7.4'
gem 'mysql2', '0.3.18'
gem 'elasticsearch-model', '0.1.7'
gem 'elasticsearch-rails', '0.1.7'
gem 'ansi'

gem 'paperclip', '4.2.1'
gem 'simple_form', '~> 3.1.0'
gem 'daemons', '1.2.2'
gem 'daemons-rails', '1.2.1'
gem 'delayed_job_active_record', '4.0.3'

gem 'capistrano', '~> 3.4.0'
gem 'capistrano-rails', '~> 1.1.2'
gem 'capistrano-rbenv', '~> 2.0.2'
gem 'whenever', '~> 0.9.2', require: false
gem 'highline'
gem 'execjs'

gem 'jbuilder', '2.2.13'
gem 'axlsx', '2.0.1'
gem 'vcardigan', '0.0.9'

gem 'unicorn', group: [:test, :production]

group :development do
  gem 'haml-rails'
  gem 'pry-rails'
  gem 'scss-lint'
end

group :development, :test do
  # gem 'rack-mini-profiler'
end

group :development, :local_test do
  gem 'quiet_assets'
  gem 'thin'
end

group :local_test do
  gem 'rspec-rails', '~> 3.2.1'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'rack-test'
  gem 'poltergeist'
  gem 'guard-rspec'
  gem 'rb-fsevent'
  gem 'launchy'
  gem 'database_cleaner'
end
