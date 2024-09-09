class carbon::cache::config {
  assert_private()

  $config_dir             = $carbon::cache::globals::config_dir
  $log_dir                = $carbon::cache::globals::log_dir
  $data_dir               = $carbon::cache::globals::data_dir
  $user                   = $carbon::cache::globals::user
  $storage_schemas        = $carbon::cache::storage_schemas
  $storage_aggregations   = $carbon::cache::storage_aggregations
  $config_options         = {
    options => deep_merge($carbon::cache::_default_options, $carbon::cache::override_options),
  }

  Concat {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    warn   => true,
  }

  file { "${config_dir}/go-carbon.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('carbon/go-carbon.conf.epp', $config_options),
  }

  concat { "${config_dir}/storage-schemas.conf":
    ensure => present,
  }

  deep_merge({
    'default' => {
      pattern    => '.*',
      retentions => ['60s:30d', '1h:5y'],
      order      => 'zz',
    }
  }, $storage_schemas).each |String[1] $schema_name, Hash $schema_config| {
    carbon::cache::storage::schema { $schema_name:
      * => $schema_config,
    }
  } 

  concat { "${config_dir}/storage-aggregation.conf":
    ensure => present,
  }

  deep_merge({
    'default' => {
      pattern    => '.*',
      order      => 'zz',
    }
  }, $storage_aggregations).each |String[1] $aggregation_name, Hash $aggregation_config| {
    carbon::cache::storage::aggregation { $aggregation_name:
      * => $aggregation_config,
    }
  }
}
