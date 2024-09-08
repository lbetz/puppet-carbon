class carbon::api::service {
  assert_private()

  $service_name = $carbon::api::globals::service_name
  $ensure       = $carbon::api::ensure
  $enable       = $carbon::api::enable

  service { $service_name:
    ensure => $ensure,
    enable => $enable,
  }
}
