require 'spec_helper'

describe 'vault' do
  RSpec.configure do |c|
    c.default_facts = {
      :architecture    => 'x86_64',
      :operatingsystem => 'Ubuntu',
      :osfamily        => 'Debian',
      :lsbdistrelease  => '10.04',
      :kernel          => 'Linux',
      :staging_http_get => 'curl'
    }
  end

  let(:pre_condition) { 'Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }' }
  context 'Should compile with no arguments' do
    it { should compile }
  end

  context 'properly escaped shellwords debian' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'debian',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/etc/init.d/vault').with_content(%r{^DAEMON_ARGS=\( server -config /etc/vault foo bar baz\\ baz\\ baz \)})}
  end

  context 'properly escaped shellwords sles' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'sles',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/etc/init.d/vault').with_content(%r{server -config "\$CONFIG_DIR" foo bar baz\\ baz\\ baz})}
  end

  context 'properly escaped shellwords systemd' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'systemd',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/lib/systemd/system/vault.service').with_content(%r{-config /etc/vault foo bar baz\\ baz\\ baz})}
  end

  context 'when config_file is passed' do
    let(:params) {{
      :config_file   => ['config_current.json'],
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'systemd',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/lib/systemd/system/vault.service').with_content(%r{-config /etc/vault/config_current.json foo bar baz\\ baz\\ baz})}
  end

  context 'properly escaped shellwords launchd' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz <baz> baz'],
      :init_style    => 'launchd',
      :backend       => {},
      :listener      => {},
    }}
    it {
      should contain_file('/Library/LaunchDaemons/io.vaultproject.daemon.plist') \
        .with_content(%r{<string>foo</string>\n\s*<string>bar</string>\n\s*<string>baz &lt;baz&gt; baz</string>})
    }
  end

  context 'properly escaped shellwords sysv' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'sysv',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/etc/init.d/vault').with_content(%r{server -config "\$CONFIG" foo bar baz\\ baz\\ baz})}
  end

  context 'properly escaped shellwords upstart' do
    let(:params) {{
      :extra_options => ['foo', 'bar', 'baz baz baz'],
      :init_style    => 'upstart',
      :backend       => {},
      :listener      => {},
    }}
    it { should contain_file('/etc/init/vault.conf').with_content(%r{server -config "\$CONFIG" foo bar baz\\ baz\\ baz})}
  end

  RSpec.shared_examples 'upstart' do
    it { should contain_file('/etc/init/vault.conf') }
    it { should_not contain_file('/lib/systemd/system/vault.service') }
  end

  RSpec.shared_examples 'systemd' do
    it { should_not contain_file('/etc/init/vault.conf') }
    it { should contain_file('/lib/systemd/system/vault.service') }
  end

  context 'on Trusty (14.04)' do
    let(:facts) {{ :lsbdistrelease => '14.04' }}
    let(:params) {{ :backend => {}, :listener => {} }}
    it_behaves_like 'upstart'
  end

  context 'on Xenial (16.04)' do
    let(:facts) {{ :lsbdistrelease => '16.04' }}
    let(:params) {{ :backend => {}, :listener => {} }}
    it_behaves_like 'systemd'
  end

  context 'on Bionic (18.04)' do
    let(:facts) {{ :lsbdistrelease => '18.04' }}
    let(:params) {{ :backend => {}, :listener => {} }}
    it_behaves_like 'systemd'
  end
end
