source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :tests do
  gem 'puppetlabs_spec_helper', '2.13.1'
  gem 'hiera-puppet-helper'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-docker'
  gem 'beaker-rspec', '6.2.4'
  gem 'beaker-puppet_install_helper'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
    gem 'puppet', puppetversion, :require => false
else
    gem 'puppet', '~> 4.5.0', :require => false
end
