class carbon::cache::config {
  assert_private()

  $config_dir             = $carbon::cache::globals::config_dir
  $log_dir                = $carbon::cache::globals::log_dir
  $data_dir               = $carbon::cache::globals::data_dir
  $user                   = $carbon::cache::globals::user
  $log_level              = $carbon::cache::log_level
  $max_cpu                = $carbon::cache::max_cpu
  $workers                = $carbon::cache::workers
  $max_updates_per_second = $carbon::cache::max_updates_per_second
  $sparse_create          = $carbon::cache::sparse_create
  $physical_size_factor   = $carbon::cache::physical_size_factor
  $flock                  = $carbon::cache::flock
  $hash_filenames         = $carbon::cache::hash_filenames
  $remove_empty_file      = $carbon::cache::remove_empty_file
  $max_size               = $carbon::cache::max_size
  $write_strategy         = $carbon::cache::write_strategy
  $storage_schemas        = $carbon::cache::storage_schemas
  $storage_aggregations   = $carbon::cache::storage_aggregations

  $tcp_enable       = $carbon::cache::tcp_enable
  $tcp_bind_address = $carbon::cache::tcp_bind_address
  $tcp_bind_port    = $carbon::cache::tcp_bind_port
  $tcp_buffer_size  = $carbon::cache::tcp_buffer_size

  $server_enable                 = $carbon::cache::server_enable
  $server_bind_address           = $carbon::cache::server_bind_address
  $server_bind_port              = $carbon::cache::server_bind_port
  $server_query_cache            = $carbon::cache::server_query_cache
  $server_streaming_query_cache  = $carbon::cache::server_streaming_query_cache
  $server_query_cache_size       = $carbon::cache::server_query_cache_size
  $server_buckets                = $carbon::cache::server_buckets
  $server_max_globs              = $carbon::cache::server_max_globs
  $server_max_metrics_rendered   = $carbon::cache::server_max_metrics_rendered
  $server_max_creates_per_second = $carbon::cache::server_max_creates_per_second

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
    content => template('carbon/go-carbon.conf.erb'),
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
