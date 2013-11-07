source 'https://rubygems.org'
ruby   '2.0.0'

gem 'sinatra'
gem 'fusion_tables'
gem 'fulcrum'

group :development, :test do
  gem 'guard'
  gem 'guard-rspec'
end

group :test do
  gem 'simplecov', require: false

  gem 'rack-test'
  gem 'rspec'
  #
  # For watching the file system and notifications on...
  #   linux
  gem 'rb-inotify', require: false
  gem 'libnotify',  require: false
  #   os x
  gem 'rb-fsevent', require: false
  gem 'growl',      require: false
  #   windows
  gem 'wdm',        platforms: [:mswin, :mingw], require: false
  gem 'rb-notifu',  require: false
end

