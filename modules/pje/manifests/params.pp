# Class: pje::params
#
# Classe com valores-chave a serem utilizados pelo módulo.
#
#
# Parâmetros:
#
# Esta classe não tem parâmetros.
#
#
# Variáveis:
#
# As variáveis definidas nesta classe funcionam como parâmetros para a
# aplicação.  Cuidou-se de incluir aqui apenas os parâmetros que fazem sentido
# para todo o sistema.
#
# [*$jboss_home*]
#   Local onde deve residir o servidor de aplicação.  É o diretório para o qual
#   o caminho $JBOSS_HOME/bin/run.sh é válido.
#
# [*$runas_user*]
#   Usuário com o qual o servidor de aplicação será executado.
#
# [*$exec_quartz*]
#   Se o executor de tarefas interno deve rodar neste servidor de aplicação.
#
# [*$ds_servername*]
#   IP ou hostname do servidor de banco de dados PostgreSQL.
#
# [*$ds_portnumber*]
#   Porta do serviço do banco de dados PostgreSQL.
#
# [*$ds_username_pje*]
#   Usuário do datasource "pje".
#   
# [*$ds_password_pje*]
#   Senha do usuário do datasource "pje".
#
# [*$ds_minpoolsize_pje*]
#   Valor mínimo do pool de conexões do datasource "pje".
#
# [*$ds_maxpoolsize_pje*]
#   Valor máximo do pool de conexões do datasource "pje".
#
# [*$ds_username_api*]
#   Usuário do datasource "api". (decisões arquiteturais da equipe)
#   
# [*$ds_password_api*]
#   Senha do usuário do datasource "api". (decisões arquiteturais da equipe)
#
# [*$ds_minpoolsize_api*]
#   Valor mínimo do pool de conexões do datasource "api". (decisões arquiteturais da equipe)
#
# [*$ds_maxpoolsize_api*]
#   Valor máximo do pool de conexões do datasource "api". (decisões arquiteturais da equipe)
#
# [*$ds_username_gim*]
#   Senha do usuário do datasource "gim". (decisões arquiteturais da equipe)
#   
# [*$ds_password_gim*]
#   Senha do usuário do datasource "gim". (decisões arquiteturais da equipe)
#
# [*$ds_minpoolsize_gim*]
#   Valor mínimo do pool de conexões do datasource "gim". (decisões arquiteturais da equipe)
#
# [*$ds_maxpoolsize_gim*]
#   Valor máximo do pool de conexões do datasource "gim". (decisões arquiteturais da equipe)
#
# [*$mail_host*]
#   IP ou hostname do servidor SMTP.
#
# [*$mail_port*]
#   Porta do serviço SMTP.
#
# [*$mail_username*]
#   Usuário para autenticação no SMTP.
#
# [*$mail_password*]
#   Senha do usuário para autenticação no SMTP.
#
# [*$jvm_heapsize*]
#   Tamanho do heap da JVM. (Parâmetro -Xms)
#
# [*$jvm_maxheapsize*]
#   Tamanho máximo do heap da JVM. (Parâmetro -Xmx)
#
# [*$jvm_permsize*]
#   Tamanho do PermGem. (Parâmetro -XX:PermSize)
#
# [*$jvm_maxpermsize*]
#   Tamanho máximo do PermGem. (Parâmetro -XX:MaxPermSize)
#
# [*$jmx_credentials*]
#   Usuário e senha para autenticação JMX.
#
#
# Exemplo de uso:
#
# include pje::params
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
class pje::params {

# global
  $jboss_home         = hiera('jboss_home')
  $runas_user         = hiera('runas_user') # vide módulo jboss
  $mail_host          = hiera('mail_host')
  $mail_port          = hiera('mail_port')
  $mail_username      = hiera('mail_username')
  $mail_password      = hiera('mail_password')

# {environment} 
  $pje_version        = hiera('pje_version')
  $ds_servername      = hiera('ds_servername')
  #ds_databasename    = undef # atributo de profile
  #binding_to         = undef # atributo de profile

# defaults
  $exec_quartz        = hiera('exec_quartz')
  $ds_portnumber      = hiera('ds_portnumber')
  $ds_username_pje    = hiera('ds_username_pje')
  $ds_password_pje    = hiera('ds_password_pje')
  $ds_minpoolsize_pje = hiera('ds_minpoolsize_pje')
  $ds_maxpoolsize_pje = hiera('ds_maxpoolsize_pje')
  $ds_username_api    = hiera('ds_username_api')
  $ds_password_api    = hiera('ds_password_api')
  $ds_minpoolsize_api = hiera('ds_minpoolsize_api')
  $ds_maxpoolsize_api = hiera('ds_maxpoolsize_api')
  $ds_username_gim    = hiera('ds_username_gim')
  $ds_password_gim    = hiera('ds_password_gim')
  $ds_minpoolsize_gim = hiera('ds_minpoolsize_gim')
  $ds_maxpoolsize_gim = hiera('ds_maxpoolsize_gim')
  $jvm_heapsize       = hiera('jvm_heapsize')
  $jvm_maxheapsize    = hiera('jvm_maxheapsize')
  $jvm_permsize       = hiera('jvm_permsize')
  $jvm_maxpermsize    = hiera('jvm_maxpermsize')
  $jmx_credentials    = hiera('jmx_credentials')

# module conf data
  $default_file       = '/etc/default/jboss-pje'

}
