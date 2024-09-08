class carbon::cache::service {
  assert_private()

  $service_name = $carbon::cache::globals::service_name
  $ensure       = $carbon::cache::ensure
  $enable       = $carbon::cache::enable

  service { $service_name:
    ensure => $ensure,
    enable => $enable,
  }
}
