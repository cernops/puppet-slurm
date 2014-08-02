source "http://rubygems.org"

group :development, :test do
  gem 'rake',                   :require => false
  gem 'rspec', '< 3.0.0',       :require => false
  gem 'rspec-puppet',           :require => false, :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem 'puppetlabs_spec_helper', :require => false
  gem 'puppet-lint',            :require => false
  gem 'puppet-syntax',          :require => false
  gem 'travis-lint',            :require => false
  gem 'simplecov',              :require => false
  gem 'coveralls',              :require => false
  gem 'rest-client', '~> 1.6.0', :require => false if RUBY_VERSION =~ /^1.8/
end

group :development do
  gem 'beaker-rspec',           :require => false
  gem 'docker-api',             :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
