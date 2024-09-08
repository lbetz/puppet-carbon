# @summary Manage the CarbinAPI server
#
# @param ensure
#
# @param enable
#
# @param manage_package
#
# @param listeners
#   Describe the port and address that carbonapi will bind to.
#
# @param prefix
#   Specify prefix for all URLs.
#
# @param not_found_status_code
#   This option controls what status code will be returned if `/render`
#   or `/metrics/find` won't return any metrics.
#
# @param concurency
#   Specify max metric requests that can be fetched in parallel.
#
# @param cpus
#   Specify amount of CPU Cores that golang can use.
#
# @param backends
#
class carbon::api (
  Stdlib::Ensure::Service $ensure                = running,
  Boolean                 $enable                = true,
  Boolean                 $manage_package        = true,
  Array[String[1]]        $listeners             = [':8542'],
  Optional[String[1]]     $prefix                = undef,
  String[3,3]             $not_found_status_code = '200',
  Integer[1]              $concurency            = 1000,
  Integer[0]              $cpus                  = 0,
  Array[String[1]]        $backends              = ['http://127.0.0.1:8080'],
) {
  require carbon::api::globals

  Class['carbon::api::install']
  -> Class['carbon::api::config']
  ~> Class['carbon::api::service']

  contain carbon::api::install
  contain carbon::api::config
  contain carbon::api::service
}
