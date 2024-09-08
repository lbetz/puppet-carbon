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
  Stdlib::Ensure::Service       $ensure                        = running,
  Boolean                       $enable                        = true,
  Boolean                       $manage_package                = true,
  Integer[1]                    $max_cpu                       = $facts['processors']['count'],
  Integer[1]                    $workers                       = $facts['processors']['cores'],
  Enum[
    'info', 'debug', 'warn',
    'error', 'panic', 'fatal']  $log_level                     = 'error',
  Integer[0]                    $max_updates_per_second        = 0,
  Boolean                       $sparse_create                 = false,
  Float[0,1]                    $physical_size_factor          = 0.75,
  Boolean                       $flock                         = false,
  Boolean                       $hash_filenames                = true,
  Boolean                       $remove_empty_file             = false,
  Integer[0]                    $max_size                      = 1000000,
  Enum['max','sorted','noop']   $write_strategy                = 'max',
  Hash[String[1],Any]           $storage_schemas               = {},
  Hash[String[1],Any]           $storage_aggregations          = {},
  Boolean                       $tcp_enable                    = true,
  Optional[Stdlib::IP::Address] $tcp_bind_address              = undef,
  Stdlib::Port                  $tcp_bind_port                 = 2003,
  Integer[0]                    $tcp_buffer_size               = 0,
  Boolean                       $server_enable                 = true,
  Optional[Stdlib::IP::Address] $server_bind_address           = undef,
  Stdlib::Port                  $server_bind_port              = 8080,
  Boolean                       $server_query_cache            = true,
  Boolean                       $server_streaming_query_cache  = false,
  Integer[0]                    $server_query_cache_size       = 0,
  Integer[1]                    $server_buckets                = 10,
  Integer[1]                    $server_max_globs              = 100,
  Integer[1]                    $server_max_metrics_rendered   = 1000000,
  Integer[0]                    $server_max_creates_per_second = 0,
) {
  require carbon::cache::globals

  Class['carbon::cache::install']
  -> Class['carbon::cache::config']
  ~> Class['carbon::cache::service']

  contain carbon::cache::install
  contain carbon::cache::config
  contain carbon::cache::service
}
