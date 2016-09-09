# == Class vault::intall
#
# Installs vault based on the parameters from init
#
class vault::install {

  if $vault::install_method == 'url' {

    if $::operatingsystem != 'darwin' {
      ensure_packages(['unzip'])
    }
    staging::file { 'vault.zip':
      source => $vault::real_download_url,
    } ->
    staging::extract { 'vault.zip':
      target  => $vault::bin_dir,
      creates => "${vault::bin_dir}/vault",
    } ->
    file { "${vault::bin_dir}/vault":
      owner => 'root',
      group => 0, # 0 instead of root because OS X uses "wheel".
      mode  => '0555',
    }
  } elsif $vault::install_method == 'package' {

    package { $vault::package_name:
      ensure => $vault::package_ensure,
    }

  } else {
    fail("The provided install method ${vault::install_method} is invalid")
  }

  if $vault::manage_user {
    user { $vault::user:
      ensure => 'present',
    }
  }
  if $vault::manage_group {
    group { $vault::group:
      ensure => 'present',
    }
  }
}
