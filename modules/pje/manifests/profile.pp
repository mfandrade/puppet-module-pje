# Define: pje::profile
#
# Definição para provisionamento dos profiles, 1o. e 2o. graus, do PJE.
#
#
# Parâmetros:
#
# [*{namevar}*]
#   jvmroute - obrigatório
#
# [*$env*]
#   env - obrigatório
#
# [*$binding_to*]
#   binding_to - obrigatório
#
# [*$jmxremote_port*]
#   jmxremote_port - obrigatório
#
# [*$ds_databasename*]
#   ds_databasename - obrigatório
#
# [*$version*]
#   version
#
# [*$ds_minpoolsize_pje*]
#   ds_minpoolsize_pje
#
# [*$ds_maxpoolsize_pje*]
#   ds_maxpoolsize_pje
#
# [*$ds_minpoolsize_api*]
#   ds_minpoolsize_api
#
# [*$ds_maxpoolsize_api*]
#   ds_maxpoolsize_api
#
# [*$ds_minpoolsize_gim*]
#   ds_minpoolsize_gim
#
# [*$ds_maxpoolsize_gim*]
#   $ds_maxpoolsize_gim
#
# [*jvm_heapsize*]
#   jvm_heapsize
#
# [*jvm_maxheapsize*]
#   jvm_maxheapsize
#
# [*jvm_permsize*]
#   jvm_permsize
#
# [*jvm_maxpermsize*]
#   jvm_maxpermsize
#
# [*exec_quartz*]
#   exec_quartz
#
#
# Variáveis:
#
# TODO: documentação das variáveis
#
#
# Exemplo de uso:
#
# pje::profile { 'int1a':
#   version         => '1.6.0',
#   env             => 'treinamento',
#   ds_databasename => 'pje_1grau_treinamento',
#   binding_to      => 'ports-default',
#   jmx_remote_port => '10150',
# }
#
# ----------------------------------------------------------------------------
# Copyright 2015 Marcelo F Andrade
#
# Marcelo F Andrade can be contacted at http://marceloandrade.info
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ----------------------------------------------------------------------------
define pje::profile (
  $env,
  $binding_to,
  $jmxremote_port,
  $ds_databasename,
  $version            = undef,
  $ds_minpoolsize_pje = undef,
  $ds_maxpoolsize_pje = undef,
  $ds_minpoolsize_api = undef,
  $ds_maxpoolsize_api = undef,
  $ds_minpoolsize_gim = undef,
  $ds_maxpoolsize_gim = undef,
  $jvm_heapsize       = undef,
  $jvm_maxheapsize    = undef,
  $jvm_permsize       = undef,
  $jvm_maxpermsize    = undef,
  $exec_quartz        = false,
) {

  include pje

# ----------------------------------------------------------------------------
  $jvmroute = $name

  if $jvmroute =~ /^pje([12])[a-z].*$/ { # EXEMPLO: pje1a, pje2btreinam
    $grau = $1

  } elsif $jvmroute =~ /^(int|ext|tre|hom|bug)[a-z]([12])$/ { # EXEMPLO: inta1, treb2
    $grau = $2

  } elsif $jvmroute =~ /^[a-zA-Z]*([12]).*$/ { # EXEMPLO: QQ-cOiSa_que_contenha_1ou2
    $grau = $1

  } else {
    fail("PJE profile '${name}' is an invalid jvmRoute pattern")
  }
  $jboss_home   = $::pje::params::jboss_home
  $profile_name = "pje-${grau}grau-default"
  $profile_path = "${jboss_home}/server/${profile_name}"

  if $ds_databasename == undef {
    fail("You need to set 'ds_databasename' parameter for pje::profile ${name}")
  }

# ----------------------------------------------------------------------------
  if ($binding_to == 'ports-default') or ($binding_to =~ /^ports-0[1-3]$/) {
    $binding_ipaddr = '0.0.0.0'
    $binding_ports  = $binding_to

  } elsif ($binding_to =~ /^[0-9]{1,3}(\.[0-9]{1,3}){3}$/) {
    $binding_ipaddr = $binding_to
    $binding_ports  = 'ports-default'

    # default-file existente usa portas. aqui só o altera se precisar.
    $default_file = $::pje::params::default_file
    $change_this  = "^JBOSS_${grau}GRAU_BINDTO=.*$"
    $to_this      = "JBOSS_${grau}GRAU_BINDTO=${binding_to}"
    exec { "config-file-${grau}":
      command => "sed -i.orig '/${change_this}/c ${to_this}' ${default_file}",
      require => Class['pje::install'],
      before  => File["${profile_name}.sh"],
    }

  } else {
    fail('You need to specify an IP address or a default port set to bind to')
  }

# ----------------------------------------------------------------------------
  $val_version            = get_value($version, $::pje::params::pje_version)
  $val_ds_minpoolsize_pje = get_value($ds_minpoolsize_pje, $::pje::params::ds_minpoolsize_pje)
  $val_ds_maxpoolsize_pje = get_value($ds_maxpoolsize_pje, $::pje::params::ds_maxpoolsize_pje)
  $val_ds_minpoolsize_api = get_value($ds_minpoolsize_api, $::pje::params::ds_minpoolsize_api)
  $val_ds_maxpoolsize_api = get_value($ds_maxpoolsize_api, $::pje::params::ds_maxpoolsize_api)
  $val_ds_minpoolsize_gim = get_value($ds_minpoolsize_gim, $::pje::params::ds_minpoolsize_gim)
  $val_ds_maxpoolsize_gim = get_value($ds_maxpoolsize_gim, $::pje::params::ds_maxpoolsize_gim)
  $val_jvm_heapsize       = get_value($jvm_heapsize, $::pje::params::jvm_heapsize)
  $val_jvm_maxheapsize    = get_value($jvm_maxheapsize, $::pje::params::jvm_maxheapsize)
  $val_jvm_permsize       = get_value($jvm_permsize, $::pje::params::jvm_permsize)
  $val_jvm_maxpermsize    = get_value($jvm_maxpermsize, $::pje::params::jvm_maxpermsize)

  Exec { path => '/bin:/usr/bin', }

# ----------------------------------------------------------------------------
  if $::pje::params::runas_user != undef {
    $jboss_user  = $::pje::params::runas_user
    $owner_group = $::pje::params::runas_user
  } else {
    $jboss_user  = 'RUNASIS' # para o script de inicialização
    $owner_group = 'root'
  }
  exec { "create-profile-${grau}":
    command => "rsync -aqz default/ ${profile_name}/",
    cwd     => "${jboss_home}/server",
    require => Class['pje::install'],
  }

  file { "${profile_name}.sh":
    ensure  => present,
    path    => "${jboss_home}/bin/${profile_name}.sh",
    content => template('pje/pje-xgrau-default.sh.erb'),
    owner   => $owner_group,
    group   => $owner_group,
    mode    => '0755',
  }
  file { "/etc/init.d/pje${grau}grau":
    ensure  => link,
    target  => "${jboss_home}/bin/${profile_name}.sh",
    require => File["${profile_name}.sh"],
  }

  $remove_from_deploy_folder = [
    "${profile_path}/deploy/ROOT.war",
    "${profile_path}/deploy/admin-console.war",
    "${profile_path}/deploy/http-invoker.sar",
    "${profile_path}/deploy/jms-ra.rar",
    "${profile_path}/deploy/mail-ra.rar",
    "${profile_path}/deploy/management",
    "${profile_path}/deploy/messaging",
    "${profile_path}/deploy/quartz-ra.rar",
    "${profile_path}/deploy/uuid-key-generator.sar",
    "${profile_path}/deploy/xnio-provider.jar",
    "${profile_path}/deploy/ejb2-container-jboss-beans.xml",
    "${profile_path}/deploy/ejb2-timer-service.xml",
    "${profile_path}/deploy/ejb3-connectors-jboss-beans.xml",
    "${profile_path}/deploy/ejb3-container-jboss-beans.xml",
    "${profile_path}/deploy/ejb3-interceptors-aop.xml",
    "${profile_path}/deploy/ejb3-timerservice-jboss-beans.xml",
    "${profile_path}/deploy/jsr88-service.xml",
    "${profile_path}/deploy/mail-service.xml",
    "${profile_path}/deploy/monitoring-service.xml",
    "${profile_path}/deploy/properties-service.xml",
    "${profile_path}/deploy/schedule-manager-service.xml",
    "${profile_path}/deploy/scheduler-service.xml",
    "${profile_path}/deploy/sqlexception-service.xml",
    "${profile_path}/deployers/bsh.deployer",
    "${profile_path}/deployers/xnio.deployer",
    "${profile_path}/deployers/messaging-definitions-jboss-beans.xml"
  ]

  file { $remove_from_deploy_folder:
    ensure  => absent,
    force   => true,
    require => Exec["create-profile-${grau}"],
  }
  file { "server-xml-${grau}":
    ensure  => present,
    path    => "${profile_path}/deploy/jbossweb.sar/server.xml",
    source  => 'puppet:///modules/pje/server.xml',
    owner   => $owner_group,
    group   => $owner_group,
    mode    => '0644',
    before  => Service["pje${grau}grau"],
    require => Exec["create-profile-${grau}"],
  }
  file { "jmx-users-${grau}":
    ensure  => present,
    owner   => $owner_group,
    group   => $owner_group,
    path    => "${profile_path}/conf/props/jmx-console-users.properties",
    content => $::pje::params::jmx_credentials,
    before  => Service["pje${grau}grau"],
    require => Exec["create-profile-${grau}"],
  }
  file { "${profile_path}/deploy/API-ds.xml":
    ensure  => present,
    owner   => $owner_group,
    group   => $owner_group,
    content => template('pje/API-ds.xml.erb'),
    require => Exec["create-profile-${grau}"],
  }
  file { "${profile_path}/deploy/GIM-ds.xml":
    ensure  => present,
    owner   => $owner_group,
    group   => $owner_group,
    content => template('pje/GIM-ds.xml.erb'),
    require => Exec["create-profile-${grau}"],
  }
  file { "${profile_path}/deploy/PJE-ds.xml":
    ensure  => present,
    owner   => $owner_group,
    group   => $owner_group,
    content => template('pje/PJE-ds.xml.erb'),
    require => Exec["create-profile-${grau}"],
  }
  file { "${profile_path}/run.conf":
    ensure  => present,
    owner   => $owner_group,
    group   => $owner_group,
    content => template('pje/run.conf.erb'),
    require => Exec["create-profile-${grau}"],
  }


  if $grau == '1' {
    $ordgrau = 'primeirograu'

  } elsif $grau == '2' {
    $ordgrau = 'segundograu'

  }
  if $env == 'producao' {
    $ctxpath = $ordgrau

  } elsif $env =~ /^(homologacao|treinamento|bugfix)$/ {
    $ctxpath = "${ordgrau}_${env}"

  } else {
    fail("PJE environment '${env}' does not exist")
  }

  $war_file = "pje-jt-${val_version}.war"
  $war_path = "${profile_path}/deploy/${ctxpath}.war"
  exec { "force-stop-${grau}":
    command => "/etc/init.d/pje${grau}grau stop; rm -rf data log tmp work deploy/${ctxpath}.war",
    cwd     => "${profile_path}",
    require => Exec["create-profile-${grau}"],
    before  => Exec["deploy-pje-${grau}"],
  }
  exec { "deploy-pje-${grau}":
    command => "unzip ${war_file} -d ${war_path}; chown -R ${owner_group}.${owner_group} ${war_path}",
    #command => "cp -fa ${war_file} ${war_path}", #; chown ${owner_group}.${owner_group} ${war_path}",
    onlyif  => "test -f ${war_file}",
    cwd     => '/tmp',
    require => Exec["create-profile-${grau}"],
    notify  => Service["pje${grau}grau"],
  }
  service { "pje${grau}grau":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => File["/etc/init.d/pje${grau}grau"],
  }

}
