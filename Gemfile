source 'https://rubygems.org'
ruby   '2.0.0'

gem 'sinatra',       '~> 1.4.4'
gem 'fusion_tables', '~> 0.4.1', github: 'kyletolle/fusion_tables', branch: 'escape-single-quotes-in-column-names'
gem 'fulcrum',       '~> 0.1.5'

group :development, :test do
  gem 'guard',         '~> 2.2.3'
  gem 'guard-rspec',   '~> 4.0.4'
end

group :test do
  gem 'simplecov', '~> 0.8.1', require: false

  gem 'rack-test', '~> 0.6.2'
  gem 'rspec',     '~> 2.14.1'
  #
  # For watching the file system and notifications on...
  #   linux
  gem 'rb-inotify', '~> 0.9.2', require: false
  gem 'libnotify',  '~> 0.8.2', require: false
  #   os x
  gem 'rb-fsevent', '~> 0.9.3', require: false
  gem 'growl',      '~> 1.0.3', require: false
  #   windows
  gem 'wdm',        '~> 0.1.0', platforms: [:mswin, :mingw], require: false
  gem 'rb-notifu',  '~> 0.0.4', require: false
end

