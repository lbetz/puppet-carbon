class carbon::cache::install {
  assert_private()

  $manage_package = $carbon::cache::manage_package
  $package_name   = $carbon::cache::globals::package_name
  $data_dir       = $carbon::cache::globals::data_dir
  $user           = $carbon::cache::globals::user
  $group          = $carbon::cache::globals::group

  if $manage_package {
    package { $package_name:
      ensure => installed,
    }

    File {
      ensure  => directory,
      require => Package[$package_name],
    }
  }

  file { [$data_dir, "${data_dir}/whisper"]:
    owner => $user,
    group => $group,
    mode  => '0750',
  }
}
