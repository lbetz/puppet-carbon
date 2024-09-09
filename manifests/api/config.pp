class carbon::api::config {
  assert_private()

  $backends = $carbon::api::backends.reduce([]) |$memo, $x| {
    $memo + [{ 'groupName' => $x[0], 'protocol' => 'auto', 'lbMethod' => 'broadcast' } + $carbon::api::backends[$x[0]]]
  }

  $carbonsearch_backends = $carbon::api::carbonsearch_backends.reduce([]) |$memo, $x| {
      $memo + [{ 'groupName' => $x[0], 'protocol' => 'auto', 'lbMethod' => 'rr' } + $carbon::api::carbonsearch_backends[$x[0]]]
    }

  $config_dir = $carbon::api::globals::config_dir
  $config     = { listeners => undef } + $carbon::api::options + {
    listeners => $carbon::api::listeners.reduce([]) |$memo, $x| {
      $memo + [{ address => $x }]
    },
    upstreams => deep_merge(delete($carbon::api::upstreams, ['backends', 'carbonsearch']), {
      backendsv2     => { backends => $backends },
      carbonsearchv2 => { backends => $carbonsearch_backends },
    }),
  }

  file { "${config_dir}/carbonapi.yaml":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => stdlib::to_yaml($config),
  }
}
