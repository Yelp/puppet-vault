# == Class vault::params
#
# This class is meant to be called from vault
# It sets variables according to platform
#
class vault::params {

  $install_method        = 'url'
  $package_name          = 'vault'
  $package_ensure        = 'latest'
  $version               = '0.6.0'
  $download_url_base     = 'https://releases.hashicorp.com/vault/'
  $download_extension    = 'zip'

  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    /^arm.*/:          { $arch = 'arm'   }
    default:           {
      fail("Unsupported kernel architecture: ${::architecture}")
    }
  }

  $os = downcase($::kernel)

  if $::operatingsystem == 'Ubuntu' {
    if versioncmp($::lsbdistrelease, '8.04') < 1 {
      $init_style = 'debian'
    } elsif versioncmp($::lsbdistrelease, '14.04') < 1  {
      $init_style = 'upstart'
    } else {  # Use systemd from Xenial (inclusive) on
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem =~ /Scientific|CentOS|RedHat|OracleLinux/ {
    if versioncmp($::operatingsystemrelease, '7.0') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style  = 'systemd'
    }
  } elsif $::operatingsystem == 'Fedora' {
    if versioncmp($::operatingsystemrelease, '12') < 0 {
      $init_style = 'sysv'
    } else {
      $init_style = 'systemd'
    }
  } elsif $::operatingsystem == 'Debian' {
    $init_style = 'debian'
  } elsif $::operatingsystem == 'SLES' {
    $init_style = 'sles'
  } elsif $::operatingsystem == 'Darwin' {
    $init_style = 'launchd'
  } elsif $::operatingsystem == 'Amazon' {
    $init_style = 'sysv'
  } else {
    $init_style = undef
  }
  if $init_style == undef {
    fail('Unsupported OS')
  }
}
