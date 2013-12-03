source 'https://rubygems.org'

group :test do
  gem "rake"
  gem "rspec"

  gem 'fontana_client_support', '~> 0.8.4'
  gem 'libgss', '~> 0.9.0'

  gem "activesupport", "~> 3.2.0"
  gem "mongoid", "~> 3.1.4"
  gem "factory_girl"
end

group :test, :development do
  gem "pry"
  gem "pry-debugger"
end

group :test, :deploy do
  gem "tengine_support", '~> 1.2.0'
end

group :deploy do
  gem 'capistrano'
  gem 'whenever', :require => false
end
