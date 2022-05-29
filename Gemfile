source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails'
gem 'bcrypt'         
gem 'faker'                   # 適当な名前を作成
gem 'will_paginate'             # pagination
gem 'bootstrap-will_paginate'    # pagination
gem 'bootstrap-sass' 
gem 'puma'    
gem 'sass-rails'
gem 'webpacker'
gem 'turbolinks'
gem 'jbuilder'
gem 'bootsnap' , require: false

group :development, :test do
  gem 'sqlite3', '~> 1.4', '>= 1.4.2'
  gem 'byebug',   platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console'          
  gem 'listen'               
  gem 'spring'       
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'   
  gem 'webdrivers'
  gem 'rails-controller-testing'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'guard'
  gem 'guard-minitest'
end

group :production do
  gem 'pg', '~> 1.3'
end

# Windows ではタイムゾーン情報用の tzinfo-data gem を含める必要があります
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]