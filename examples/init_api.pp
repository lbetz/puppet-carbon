class { 'carbon::api':
  listeners  => ['127.0.0.1:8542', '[::1]:8542'],
  options    => {
    useCachingDNSResolver => false,
    cachingDNSRefreshTime => '1m',
  },
  upstreams  => {
    graphite09compat  => false,
    keepAliveInterval => '30s',
    backendsv2        => {
      timeouts => {
        find => '2s',
        render => '10s',
        connect => '500ms',
      },
      keepAliveInterval => '30s',
      maxIdleConnsPerHost => 10,
    },
    carbonsearchv2 => {
      prefix => 'virt.v1.*',
    },
  },
  backends   => {
    go-carbon-group1 => {
      maxTries => 3,
      servers  => ['http://127.0.0.1:8080', 'http://127.0.0.1:8081'],
    },
    go-carbon-group2 => {
      servers  => ['http://127.0.0.1:8082'],
    },
  },
}
