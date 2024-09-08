class carbon::api::config {
  assert_private()

  $config_dir = $carbon::api::globals::config_dir
  $config     = {
    listeners             => $carbon::api::listeners,
    prefix                => $carbon::api::prefix,
    not_found_status_code => $carbon::api::not_found_status_code,
    concurency            => $carbon::api::concurency,
    cpus                  => $carbon::api::cpus,
    backends              => $carbon::api::backends,
  }

  file { "${config_dir}/carbonapi.yaml":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('carbon/carbonapi.yaml.epp', $config),
  }
}
