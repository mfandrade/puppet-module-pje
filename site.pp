node /^pje8-jb-(int|ext)-([a-z]).trt8.net$/ {

  include pje::params

  pje::profile { "${1}${2}1":
    version         => $::pje::params::pje_version,
    binding_to      => '10.8.14.253',
    jmxremote_port  => '10150',
    env             => $environment,
    ds_databasename => "pje_1grau_${environment}",
  }

  pje::profile { "${1}${2}2":
    version         => $::pje::params::pje_version,
    binding_to      => '10.8.14.254',
    jmxremote_port  => '10151',
    env             => $environment,
    ds_databasename => "pje_2grau_${environment}",
  }

}

node 'pje8-jb-treinamento.trt8.net' {

  include pje::params

  pje::profile { 'pje1atreinam':
    version         => $::pje::params::pje_version,
    binding_to      => '10.8.14.253',
    jmxremote_port  => '10150',
    env             => 'treinamento',
    ds_databasename => 'pje_1grau_treinamento',
  }

  pje::profile { 'pje2atreinam':
    version         => $::pje::params::pje_version,
    binding_to      => '10.8.14.254',
    jmxremote_port  => '10151',
    env             => 'treinamento',
    ds_databasename => 'pje_2grau_treinamento',
  }

}
