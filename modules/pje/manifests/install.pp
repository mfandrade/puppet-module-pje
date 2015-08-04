# == Classe: pje::install
#
# Classe para gerenciar os requisitos básicos para se executar o PJE.  Neste
# momento, a saber, o servidor de aplicação JBoss (vide módulo específico) e os
# arquivos necessários: keystore, driver do postgresql e init script.
#
# === Parâmetros
#
# Esta classe não tem parâmetros e pode ser usada apenas com `include
# pje::install`.  Os valores de que ela precisa estão definidas na classe
# pje::params.
#
# === Variáveis
#
# [*jboss_home*]
#   Variável definida com o valor do parâmetro correspondente para reduzir
#   tamanho da linha e evitar alerta do `puppet-lint`.
#
# [*initscript_name*]
#   Idem para a variável jboss_home.
#
# === Exemplo
#
#```
#   class { pje::install: version => '1.6.0', }
#```
#
# ===
# Copyright 2015 Marcelo de Freitas Andrade
#
# Marcelo F Andrade can be contacted at <mfandrade@gmail.com>
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
class pje::install($version) {

  include pje::params

  $jboss_home = $::pje::params::jboss_home
  class { 'jboss':
    version    => '5.1.1',
    jboss_home => $jboss_home,
  }

  file { 'aplicacaojt.keystore':
    ensure  => present,
    path    => '/usr/java/default/jre/lib/security/aplicacaojt.keystore',
    source  => 'puppet:///modules/pje/aplicacaojt.keystore',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['jboss'], # por causa do java
  }

  file { 'drive-postgresql':
    ensure  => present,
    path    => "${jboss_home}/common/lib/postgresql-9.3-1103.jdbc4.jar",
    source  => 'puppet:///modules/pje/postgresql-9.3-1103.jdbc4.jar',
    require => Class['jboss'], # por causa do jboss_home, obviamente
  }

  file { "/etc/default/jboss-pje":
    ensure  => present,
    source  => 'puppet:///modules/pje/jboss-pje',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  $war_name = "pje-jt-${version}.war"
  $url      = "http://portal.pje.redejt/nexus/content/repositories/releases/br/jus/csjt/pje/pje-jt/${version}/${war_name}"
  file { "/tmp/${war_name}":
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => ["puppet:///modules/pje/${war_name}", 'file:///dev/null'],
  }
  exec { 'download-war':
    command => "wget -c '${url}'",
    timeout => '1200',
    unless  => "test -f ${war_name} && unzip -tqq ${war_name}",
    cwd     => '/tmp',
    path    => '/usr/bin',
    require => [Package['unzip'], File["/tmp/${war_name}"]],
  }

}
