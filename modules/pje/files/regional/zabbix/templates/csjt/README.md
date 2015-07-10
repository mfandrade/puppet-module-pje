# Templates para o monitoramento pelo ZABBIX
Esses templates ter�o que ser importados para o zabbix

Templates respons�veis por monitorar os servi�oes que sustent�o o PJe; (Apache, JBoss, PostgreSQL)

## Como Importar
Para importar o template acesse: "Configuration" -> "Templates" - > "Import". Selecione o arquivo para a importa��o e clique no bot�o "Import".

## 1.Template Apache Stats.xml

Template respons�vel por monitorar os servi�os do **Apache**

Nesse template adione os Hosts que correspondem ao APACHE.

Obs.: � necess�rio adicionar o arquivo zapache no zabbix. Olhe no arquivo README.md no diret�rio zabbix/script aqui no GITLAB.

## 2.Template JBoss 5 PJE.xml

Template respons�vel por monitorar os servi�oes do **JBoss**

Nesse template adione os Hosts que correspondem ao JBoss.

## 3.Template PostgreSQL.xml

Template respons�vel por monitorar os servi�oes do **PostgreSQL**

## 4.Template Regionais.xml

Template respons�vel por monitorar as regionais, se elas est�o funcionando.

## 5.Template WebService.xml

Template respons�vel por monitorar os servi�os: OAB, RFB, BANCOs.