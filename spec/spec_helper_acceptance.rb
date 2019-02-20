require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      puppet_module_install(:source => module_root, :module_name => 'vault')
      on host, puppet('module install puppetlabs-stdlib'), {:acceptable_exit_codes => [0]}
      on host, puppet('module install puppet/staging'), {:acceptable_exit_codes => [0]}
    end
  end
end
