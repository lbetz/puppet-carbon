class carbon::cache::globals (
  String[1]             $package_name = 'go-carbon',
  String[1]             $service_name = 'go-carbon',
  String[1]             $user         = 'carbon',
  String[1]             $group        = 'carbon',
  Stdlib::Absolutepath  $config_dir   = '/etc/go-carbon',
  Stdlib::Absolutepath  $data_dir     = '/var/lib/graphite',
  Stdlib::Absolutepath  $log_dir      = '/var/log/go-carbon',
) {
}
