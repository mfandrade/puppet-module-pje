#class pje::profile($jboss_home = "/srv/jboss", $base_profile = "default", $profile_name = "pje-1grau-default") {
class pje::profile(
  $jboss_home      = "/srv/jboss",
  $profile_name    = "pje-1grau-default",
  $binding_ports   = "ports-default",
  $binding_ipaddr  = '10.8.17.222',
  $jvmroute        = 'pje1a',
  $jmxremote_port  = 9001,
  $quartz          = false,
  $db_server       = '10.8.14.206',
  $db_name         = 'pje_1grau_producao',
  $username_pje    = 'pje',
  $password_pje    = 'PjEcSjT',
  $minpoolsize_pje = 5,
  $maxpoolsize_pje = 40,
  $username_api    = 'pje_usuario_servico_api',
  $password_api    = 'PjEcSjT',
  $minpoolsize_api = 1,
  $maxpoolsize_api = 20,
  $username_gim    = 'pje_usuario_servico_gim',
  $password_gim    = 'PjEcSjT',
  $minpoolsize_gim = 1,
  $maxpoolsize_gim = 20
) {
  
  file { "$profile_name":
    path    => "$jboss_home/server/$profile_name",
    ensure  => present,
    source  => 'puppet:///modules/pje/pje-xgrau-default',
    recurse => true,
  }

  $remove_from_deploy_folder = [
    "$jboss_home/server/$profile_name/deploy/ROOT.war",
    "$jboss_home/server/$profile_name/deploy/admin-console.war",
    "$jboss_home/server/$profile_name/deploy/http-invoker.sar",
    "$jboss_home/server/$profile_name/deploy/jms-ra.rar",
    "$jboss_home/server/$profile_name/deploy/mail-ra.rar",
    "$jboss_home/server/$profile_name/deploy/management",
    "$jboss_home/server/$profile_name/deploy/messaging",
    "$jboss_home/server/$profile_name/deploy/quartz-ra.rar",
    "$jboss_home/server/$profile_name/deploy/uuid-key-generator.sar",
    "$jboss_home/server/$profile_name/deploy/xnio-provider.jar",
    "$jboss_home/server/$profile_name/deploy/ejb2-container-jboss-beans.xml",
    "$jboss_home/server/$profile_name/deploy/ejb2-timer-service.xml",
    "$jboss_home/server/$profile_name/deploy/ejb3-connectors-jboss-beans.xml",
    "$jboss_home/server/$profile_name/deploy/ejb3-container-jboss-beans.xml",
    "$jboss_home/server/$profile_name/deploy/ejb3-interceptors-aop.xml",
    "$jboss_home/server/$profile_name/deploy/ejb3-timerservice-jboss-beans.xml",
    "$jboss_home/server/$profile_name/deploy/jsr88-service.xml",
    "$jboss_home/server/$profile_name/deploy/mail-service.xml",
    "$jboss_home/server/$profile_name/deploy/monitoring-service.xml",
    "$jboss_home/server/$profile_name/deploy/properties-service.xml",
    "$jboss_home/server/$profile_name/deploy/schedule-manager-service.xml",
    "$jboss_home/server/$profile_name/deploy/scheduler-service.xml",
    "$jboss_home/server/$profile_name/deploy/sqlexception-service.xml",
    "$jboss_home/server/$profile_name/deployers/bsh.deployer",
    "$jboss_home/server/$profile_name/deployers/xnio.deployer",
    "$jboss_home/server/$profile_name/deployers/messaging-definitions-jboss-beans.xml"
  ]

  file { $remove_from_deploy_folder:
    ensure  => absent,
    force   => true,
    require => File["$profile_name"],
  }

  file { 'aplicacaojt.keystore':
    path   => '/usr/java/default/jre/lib/security/aplicacaojt.keystore',
    ensure => present,
    source => 'puppet:///modules/pje/aplicacaojt.keystore',
  }
  file { 'drive-postgresql':
    ensure  => present,
    path    => "$jboss_home/common/lib/postgresql-9.3-1103.jdbc4.jar",
    source  => 'puppet:///modules/pje/postgresql-9.3-1103.jdbc4.jar',
  }

  file { 'API-ds.xml':
    ensure  => present,
    path    => "$jboss_home/server/$profile_name/deploy/API-ds.xml",
    content => template('pje/API-ds.xml.erb'),
  }
  file { 'GIM-ds.xml':
    ensure  => present,
    path    => "$jboss_home/server/$profile_name/deploy/GIM-ds.xml",
    content => template('pje/GIM-ds.xml.erb'),
  }
  file { 'PJE-ds.xml':
    ensure  => present,
    path    => "$jboss_home/server/$profile_name/deploy/PJE-ds.xml",
    content => template('pje/PJE-ds.xml.erb'),
  }

  file { 'run.conf':
    ensure  => present,
    path    => "$jboss_home/server/$profile_name/run.conf",
    content => template('pje/run.conf.erb'),
  }

  file { 'pje-xgrau-default.sh':
    ensure  => present,
    path    => "$jboss_home/bin/pje-1grau-default.sh",
    content => template('pje/pje-xgrau-default.sh'),
  }

}
