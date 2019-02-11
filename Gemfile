source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :tests do
  gem 'puppetlabs_spec_helper'
  gem 'hiera-puppet-helper'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-docker'
  gem 'beaker-rspec'
  gem 'beaker-puppet_install_helper'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
    gem 'puppet', puppetversion, :require => false
else
    gem 'puppet', '~> 4.5.0', :require => false
end
