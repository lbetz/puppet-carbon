class carbon::api::install {
  assert_private()

  $package_name   = $carbon::api::globals::package_name
  $config_dir     = $carbon::api::globals::config_dir
  $manage_package = $carbon::api::manage_package

  if $manage_package {
    package { $package_name:
      ensure => installed,
    }

    File {
      ensure => directory,
      require => Package[$package_name],
    }
  }

  file { $config_dir:
    owner => 'root',
    group => 'root',
    mode  => '0755',
  }
}
