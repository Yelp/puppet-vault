source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :tests do
  gem 'puppetlabs_spec_helper'
  gem 'hiera-puppet-helper'
end

group :system_tests do
  gem "beaker", "> 2.0.0"
  gem "beaker-rspec", ">= 5.1.0"
  gem 'beaker-docker'
  gem 'beaker-puppet_install_helper'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
    gem 'puppet', puppetversion, :require => false
else
    gem 'puppet', '~> 6.13', :require => false
end
