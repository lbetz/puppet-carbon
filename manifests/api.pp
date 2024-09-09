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
# @param upstreams
#
# @param backends
#   Backends of upstream backendsv2. Overrides option backends set in backendsv2.
#
# @param carbonsearch_backends
#   Backends of upstream carbonsearchv2. Overrides option backends set in carbonsearchv2.
#
class carbon::api (
  Hash[String[1],Hash]      $backends,
  Stdlib::Ensure::Service   $ensure                = running,
  Boolean                   $enable                = true,
  Boolean                   $manage_package        = true,
  Array[String[1]]          $listeners             = [':8542'],
  Hash[String[1],Any]       $options               = {},
  Hash[String[1],Any]       $upstreams             = {},
  Hash[String[1],Hash]      $carbonsearch_backends = {},
) {
  require carbon::api::globals

  Class['carbon::api::install']
  -> Class['carbon::api::config']
  ~> Class['carbon::api::service']

  contain carbon::api::install
  contain carbon::api::config
  contain carbon::api::service
}
