require 'spec_helper_acceptance'

describe 'vault' do
  it 'should install the right version' do
    apply_manifest('include vault', :catch_failures => true)
    expect(file('/usr/local/bin/vault')).to exist
    expect(file('/etc/vault')).to_not exist
    expect(command('/usr/local/bin/vault version').stdout).to match(/Vault v0\.6\.0/)
  end

  it 'should start the service' do
    # Sometimes Vault expects strings instead of booleans, hence the quoted 'true' below
    manifest = <<-EOM
    file {'/etc/vault':
      ensure => directory
    }
    -> class {'vault':
      config_hash => {'disable_mlock' => true},
      backend => {'file' => {'path' => '/tmp/data.vault'}},
      listener => {'tcp' => {'address' => '127.0.0.1:18200', 'tls_disable' => 'true'}},
    }
    EOM
    apply_manifest(manifest, :catch_failures => true)
    # Vault doesn't die fast enough on config errors: the `be_running` below
    # might think the service is up while it's about to die. Sleep to work around that.
    expect(command('sleep 1').exit_status).to be_zero
    expect(service('vault')).to be_running
  end
end
