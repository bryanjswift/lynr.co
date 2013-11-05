source 'https://rubygems.org'
source 'https://code.stripe.com'

ruby '1.9.3'

gem 'bcrypt-ruby',      '3.1.2'
gem 'bson_ext',         '1.9.2'
gem 'bunny',            '1.0.0'
gem 'kramdown',         '1.2.0'
gem 'libxml-ruby',      '2.7.0'
gem 'log4r',            '1.1.10'
gem 'mongo',            '1.9.2'
gem 'ramaze',           '2012.12.08'
gem 'stripe',           '1.8.8'
gem 'yajl-ruby',        '1.1.0'

group :development do
  gem 'guard'
  gem 'guard-shell'
  gem 'guard-bundler'
  gem 'guard-rake'

  gem 'pry'

  gem 'rb-fchange', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-inotify', :require => false
end

group :heroku do
  gem 'less',           '2.4.0'
  gem 'therubyracer'
  gem 'unicorn',        '4.7.0'
end

group :local do
  gem 'shotgun',        '0.9'
end

group :test do
  gem 'rspec'

  gem 'codeclimate-test-reporter'

  gem 'guard-rspec'
end

group :vagrant do
  gem 'unicorn',        '4.7.0'
end
