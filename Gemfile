source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'jquery-rails', '~> 2.0.2'
gem 'i18n', '~> 0.6.0'
gem 'coderay', '~> 1.0.9'
gem 'fastercsv', '~> 1.5.0', :platforms => [:mri_18, :mingw_18, :jruby]
gem 'builder', '3.0.0'
gem 'method_decorators'
gem 'pg', '0.15.0'
gem 'haml'
gem 'rspec-rails'

# Optional gem for LDAP authentication
group :ldap do
  gem 'net-ldap', '~> 0.3.1'
end

# Optional gem for OpenID authentication
group :openid do
  gem 'ruby-openid', '~> 2.1.4', :require => 'openid'
  gem 'rack-openid'
end

# Optional gem for exporting the gantt to a PNG file, not supported with jruby
platforms :mri, :mingw do
  group :rmagick do
    # RMagick 2 supports ruby 1.9
    # RMagick 1 would be fine for ruby 1.8 but Bundler does not support
    # different requirements for the same gem on different platforms
    gem 'rmagick', '>= 2.0.0'
  end
end

group :development do
  gem 'rdoc', '>= 2.4.2'
  gem 'yard'
end

group :test do
  gem 'shoulda', '~> 3.3.2'
  gem 'mocha', '>= 0.14', :require => 'mocha/api'
  if RUBY_VERSION >= '1.9.3'
    gem 'capybara', '~> 2.1.0'
    gem 'selenium-webdriver'
    gem 'database_cleaner'
  end
end

group :production do
  gem 'pg', '0.15.0'
end

local_gemfile = File.join(File.dirname(__FILE__), 'Gemfile.local')
if File.exists?(local_gemfile)
  puts 'Loading Gemfile.local ...' if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(local_gemfile)
end

# Load plugins' Gemfiles
Dir.glob File.expand_path('../plugins/*/Gemfile', __FILE__) do |file|
  puts 'Loading #{file} ...' if $DEBUG # `ruby -d` or `bundle -v`
  #TODO: switch to 'eval_gemfile file' when bundler >= 1.2.0 will be required (rails 4)
  instance_eval File.read(file), file
end
