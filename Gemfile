source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :test do
  gem 'rake',                     :require => false
  gem 'rspec-puppet',             :require => false, :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem 'rspec-puppet-facts',       :require => false
  gem 'puppetlabs_spec_helper',   :require => false
  gem 'serverspec',               :require => false
  gem 'puppet-lint',              :require => false
  gem 'puppet-syntax',            :require => false
  gem 'beaker', '~> 1.x',         :require => false if RUBY_VERSION =~ /^1.8/
  gem 'beaker',                   :require => false unless RUBY_VERSION =~ /^1.8/
  gem 'beaker-rspec',             :require => false
  gem 'pry',                      :require => false unless RUBY_VERSION =~ /^1.8/
  gem 'simplecov',                :require => false
  gem 'coveralls',                :require => false
  gem 'rest-client', '~> 1.6.0',  :require => false if RUBY_VERSION =~ /^1.8/
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
