# @summary
#   Manage go-carbon.
#
# @param ensure
#
# @param enable
#
# @param manage_package
#
# @param max_cpu
#   Increase for configuration with multi persister workers.
#
# @param workers
#   Worker threads count. Metrics sharded by "crc32(metricName) % workers"
#
# @param log_level
#   Log level.
#
# @param max_updates_per_second
#   Limits the number of whisper update_many() calls per second. 0 - no limit.
#
# @param sparse_create
#   Sparse file creation.
#
# @param physical_size_factor
#
# @param flock
#   use flock on every file call (ensures consistency if there
#   are concurrent read/writes to the same file).
#
# @param hash_filenames
#   Use hashed filenames for tagged metrics instead of human readable.
#
# @param remove_empty_file
#   Automatically delete empty whisper file caused by edge cases like server reboot.
#
# @param max_size
#   Limit of in-memory stored points (not metrics).
#
# @param write_strategy
#   Capacity of queue between receivers and cache Strategy to persist metrics.
#   max - Write metrics with most unwritten datapoints first.
#   sorted - Sort by timestamp of first unwritten datapoint.
#   noop - Pick metrics to write in unspecified order, requires
#          least CPU and improves cache responsiveness.
#
# @param storage_schemas
#
# @param storage_aggregations
#
# @param tcp_enable
#   
# @param tcp_bind_address
#   
# @param tcp_bind_port
#   
# @param tcp_buffer_size
#   Optional internal queue between receiver and cache.   
#
# @param server_enable
#   Enable carbonserver support.
#
# @param server_address
#
# @param server_bind_port
#
# @param server_query_cache
#   Enable /render cache, it will cache the result for 1 minute.
#
# @param server_streaming_query_cache
#   Enable carbonV2 gRPC streaming render cache, it will cache the result for 1 minute.
#
# @param server_query_cache_size
#   Cache size, 0 for unlimited.
#
# @param server_buckets
#   Buckets to track response times.
#
# @param server_max_globs
#   Maximum amount of globs in a single metric in index. This value is used
#   to speed-up /find requests with a lot of globs, but will lead to
#   increased memory consumption.
#
# @param server_max_metrics_rendered
#   Maximum metrics could be returned in render request.
#
# @param server_max_creates_per_second
#   Hard limits the number of whisper files that get created each second.
#
class carbon::cache (
  Stdlib::Ensure::Service       $ensure               = running,
  Boolean                       $enable               = true,
  Boolean                       $manage_package       = true,
  Hash                          $override_options     = {},
  Hash[String[1],Any]           $storage_schemas      = {},
  Hash[String[1],Any]           $storage_aggregations = {},
) {
  require carbon::cache::globals

  $_default_options = deep_merge({
      common    => { 'user' => $carbon::cache::globals::user },
      whisper   => {
        'data-dir'         => "${carbon::cache::globals::data_dir}/whisper",
        'schemas-file'     => "${carbon::cache::globals::config_dir}/storage-schemas.conf",
        'aggregation-file' => "${carbon::cache::globals::config_dir}/storage-aggregation.conf",
      },
      'dump'    => { 'path' => "${carbon::cache::globals::data_dir}/dump" },
      'logging' => { 'file' => "${carbon::cache::globals::log_dir}/go-carbon.log" },
    },
    $carbon::cache::globals::default_options)

  Class['carbon::cache::install']
  -> Class['carbon::cache::config']
  ~> Class['carbon::cache::service']

  contain carbon::cache::install
  contain carbon::cache::config
  contain carbon::cache::service
}
