source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Bootstrap for templating
gem 'bootstrap-sass'
#for nice icons
gem 'font-awesome-rails'
#for mikes shitty dev box fix
#gem "puma"
#for background jobs
gem 'sidekiq'
#for sidekiq db support stuff
gem 'redis'
gem 'autoprefixer-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
#for search using elasticsearch backend
gem 'searchkick'
#add easy to control pagination for search results
gem 'will_paginate'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
# Devise for user authentication
gem 'devise'
# reddit API for Ruby
gem 'redditkit'
# Use Unicorn as the app server
# gem 'unicorn'

# for Heroku
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'bonsai-elasticsearch-rails'


group :development, :test do
  gem 'quiet_assets' # Turns off the Rails asset pipeline log
  gem 'bullet' #help reduce sql query speeds
  gem 'lol_dba' #helps scan for better indexing
  gem 'rails_best_practices' #helps scan for rails best practices in code
  gem 'hirb' # Formats 'rails console' with tables. Activate with `require 'hirb'` then `Hirb.enable`
end
