define carbon::cache::storage::aggregation (
  String[1]             $pattern,
  String[2,2]           $order,
  String[1]             $aggregation_name = $title,
  Float[0,1]            $factor           = 0.5,
  Enum[
    'average','sum',
    'min','max','last'] $method           = 'average',
) {
  require carbon::cache::globals

  $config_dir  = $carbon::cache::globals::config_dir
  $aggregation = {
    aggregation_name => $aggregation_name,
    pattern          => $pattern,
    factor           => $factor,
    method           => $method,
  }

  concat::fragment { "carbon::cache::storage::aggregation::${aggregation_name}":
    target  => "${config_dir}/storage-aggregation.conf",
    content => epp('carbon/storage-aggregation.epp', $aggregation),
    order   => $order,
  }
}
