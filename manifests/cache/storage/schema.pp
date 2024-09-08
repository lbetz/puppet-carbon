define carbon::cache::storage::schema(
  String[1]          $pattern,
  Array[String[1]]   $retentions,
  String[2,2]        $order,
  String[1]          $schema_name = $title,
  Boolean            $compressed  = false,
) {
  require carbon::cache::globals

  $config_dir = $carbon::cache::globals::config_dir
  $schema     = {
    schema_name => $schema_name,
    pattern     => $pattern,
    retentions  => $retentions,
    compressed  => $compressed,
  }

  concat::fragment { "carbon::cache::storage::scheme::${schema_name}":
    target  => "${config_dir}/storage-schemas.conf",
    content => epp('carbon/storage-schema.epp', $schema),
    order   => $order,
  }
}
