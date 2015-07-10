## Descri��o dos templates.

**1.** Apache (Template Apache.xml)

Utiliza o script python status_apache.py que deve ser colocado na pasta /usr/lib/zabbix/externalscripts/ do servidor zabbix. Esse script (executado no pr�prio servidor zabbix) faz um parsing da p�gina de server-status do apache e envia informa��es aos itens do tipo Zabbix Trapper (itens passivos).

O diferencial dessa solu��o em rela��o a outras (apenas Zabbix) que pesquisei na Internet:
   - Em ouras solu��es cada um dos itens � consultado de forma ativa (um de cada vez), consumindo mais recursos. Essa solu��o faz o parsing de todas as infroma��es de uma vez, sendo mais perform�tica.
   - Nas solu��es de monitoramento passivas, normalmente o script � colocado no crontab de cada um dos servidores a serem monitorados, o que dificulta a administra��o da solu��o de monitoramento. Nessa solu��o, o script � executado no servidor zabbix (n�o � necess�rio alterar crontab dos clientes monitorados) e ativado atrav�s de um item ativo do zabbix (o controle de intervalo de monitoramento pode ser feito pelo pr�prio Zabbix)

Resumindo, essa solu��o tem as vantagens de performance das solu��es de monitoramento passivas, e � praticamente "plug n play", ou seja, para adicionar novos hosts, basta incu�-los no template.

Esse template inclui um gatilho para avisar caso o n�mero de conex�es simult�neas esteja pr�ximo do m�ximo e alguns gr�ficos onde podemos ver o n�mero de conex�es utilizadas detalhadas por estado. Por exemplo quantas conex�es est�o em keep alive (abertas, por�m n�o utilizadas), reading request, sending reply, etc...
Em anexo um gr�fico de exemplo: "Apache Status.jpg"

OBS: O script status_apache.py n�o � de minha autoria, eu fiz apenas pequenas altera��es nele para adapt�-lo � nossa infra. As informa��es do autor est�o no cabe�alho do script.

**2.** JBoss e itens espec�ficos do PJE (Template JMX Generic.xml, Template JBoss 5 PJE.xml, Template PJE Aggregate.xml e Screens PJE.xml)

Fizemos uma varredura nos atributos dos MBeans disponibilizados pelo JBoss via JMX e acrescentamos muitos itens que s�o relevantes e que n�o vinham no template original do Zabbix nem nos templates dispon�veis na Internet.

**2.1** Itens
Um resumo dos itens acrescentados:
* Template JMX Generic
    - Informa��es do ultimo GC (LastGcInfo)
* Template JBoss 5 PJE
    - Informa��es sobre sess�es (sess�es ativas, tempos m�dio e m�ximo das sess�es)
    - Threads AJP (quantas est�o ocupadas, em keep alive, etc)
    - Cluster 2grau (Jgroups)
    - Messaging (JMS)
    - Transaction Manager
    - Access e hit count do cache (Web Cache)
    - GlobalRequestProcessor (processing time, error count, etc)
    - Informa��es de cada Servlet do PJE
    - Conex�es com o Banco (JCA Datasources)
* Template PJE Aggregate

**2.2** Gatilhos
Adaptamos a vers�o original do template do Zabbix desabilitando alguns gatilhos que davam muitos falsos positivos e criando outros. Seguem os mais relevantes:

* Template JMX Generic

  - {$CMS_OLD_GEN_TRIGGER}% CMS Old Gen Used After GC on {HOST.NAME} - Avisa quando a CMS Old Gen ap�s o GC est� acima de 60% por padr�o. O gatilho antigo monitorava a mem�ria utilizada, por�m o comportamento normal do GC � deixar a mem�ria chegar a n�veis de utiliza��o muito altos antes de limp�-la. Esse novo gatilho monitora a mem�ria sempre *ap�s* o GC, dessa forma temos um indicador mais adequado para medir a utiliza��o da mem�ria descontando o lixo. Esse indicador � um dos pontos chave para auxiliar na decis�o de aumentar o n�mero de inst�ncias.

  - {$MP_CMS_PERM_GEN_TRIGGER_MULTIPLIER}% mp CMS Perm Gen used on {HOST.NAME} - Avisa quando a Perm Gen (mem�ria que contem as classes do PJE) est� acima de 90% por padr�o.

* Template JBoss 5 PJE
  - JBoss JGroups NumMembers < {$TRIGGER_JGROUPS_MEMBERS} - Avisa quando 1 ou mais membros estiverem fora do cluster

  - JBoss Datasource PJE_DESCANSO_QUARTZ_DS {$TRIGGER_DS}% Full - Avisa quando algum dos datasources estiver cheio

  - JBoss Datasource QueueSize > {$TRIGGER_DS_QUEUESIZE} -  Avisa quando a fila de um DS for maior que 5 por padr�o

**2.3** Gr�ficos e Screens
Adicionadas no gr�fico da Old Gen as informa��es do ultimo GC
Criadas Screens com o gr�fico da Old Gen de todos os JBoss para melhor visualiza��o da carga total no PJE e do balanceamento entre os JBoss.

OBS: As screens est�o no arquivo Screens PJE.xml pois n�o fazem parte dos templates.

**2.4** Template PJE Aggregate
Com o intuito de simplificar a an�lise do ambiente, criamos esse template com itens do tipo aggregate do Zabbix que permitem somar os itens de v�rios servidores JBoss.
Isso permite que tenhamos informa��o, por exemplo, do n�mero total de sess�es, mem�ria usada, threads, load dos servidores, etc
Segue em anexo o arquivo "Sessoes ativas 1grau.jpg" com o gr�fico da soma das sess�es ativas em todos os JBoss de 1grau como exemplo.
Para facilitar o uso dessa funcionalidade, � recomendavel criar 1 Host Group para cada grupo que pretendemos agregar as informa��es:
PJE JBoss
PJE JBoss 1grau
PJE JBoss 1grau Externos
PJE JBoss 1grau Internos
PJE JBoss 2grau
PJE JBoss 2grau Externos
PJE JBoss 2grau Internos

Para cada Host Group, criamos um Host manualmente, adicionamos o "Template PJE Aggregate" e definimos a macro {$SERVER_GROUP} com o nome do Host Group correspondente. Por exemplo, criamos o host "PJE 1grau", e definimos a macro {$SERVER_GROUP} = "PJE JBoss 1grau". Nesse exemplo, nos gr�ficos do host "PJE 1grau" aparecer�o as informa��es somadas de todos os JBoss de 1grau.

Tamb�m em anexo no arquivo "PJE Aggregate.xml", est� o export com esses hosts criados j� ligados ao template e com as macros definidas. Basta apenas criar os host groups correspondentes e adicionar os servidores JBoss a eles.

**2.5** TODO (O que falta alterar nos templates)

- Analisar os itens e incluir gatilhos, gr�ficos e screens relevantes
- Criar itens agregados (somando os valores de todos os JBoss) relevantes
- Separar em templates diferentes os monitoramentos espec�ficos do PJE dos gen�ricos do JBoss
- Pesquisar uma forma do zabbix fazer LLD (low level discovery) p/ os itens do JMX (utilizar vers�o customizada do java gateway?)
- Incluir outros Servlets do PJE (foram inclu�dos apenas 2 - o ideal seria usar LLD, desta forma os Servlets seriam descobertos automaticamente e o item poderia ficar no template gen�rico do JBoss, servindo para qualquer aplica��o)
- LLD para os datasources (JCA)
- Revisar itens, colocando as unidades (segundos, ms, Bytes, etc)

OBS: Para que os itens JMX que capturam informa��es do ultimo GC (LastGcInfo) do Template JMX Generic funcionassem, foi necess�rio fazer uma pequena altera��o no c�digo fonte do Java Gateway do Zabbix para suportar o tipo de dado TabularDataSupport.
Segue em anexo o arquivo zabbix-java-gateway-2.0.8.jar que deve ser copiado para a pasta /usr/sbin/zabbix_java/bin/ (substituindo o original).
Caso estejam usando outra vers�o que n�o seja a 2.0.8, abaixo est� o diff com a modifica��o necess�ria para acrescentar o suporte ao TabularDataSupport:

diff zabbix-2.0.8/src/zabbix_java/src/com/zabbix/gateway/JMXItemChecker.java-orig zabbix-2.0.8/src/zabbix_java/src/com/zabbix/gateway/JMXItemChecker.java
237a238,267
>                 else if (dataObject instanceof TabularDataSupport)
>                 {
>                         logger.trace("'{}' contains tabular data", dataObject);
> 
>                         TabularDataSupport tabular = (TabularDataSupport)dataObject;
> 
>                         //logger.warn("tabular data type:'{}'", tabular.getTabularType());
> 
>                         String dataObjectName;
>                         String newFieldNames = "";
> 
>                         int sep = HelperFunctionChest.separatorIndex(fieldNames);
> 
>                         if (-1 != sep)
>                         {
>                                 dataObjectName = fieldNames.substring(0, sep);
>                                 newFieldNames = fieldNames.substring(sep + 1);
>                         }
>                         else
>                                 dataObjectName = fieldNames;
> 
>                         // unescape possible dots or backslashes that were escaped by user
>                         dataObjectName = HelperFunctionChest.unescapeUserInput(dataObjectName);
> 
>                         //logger.warn("dataObjectName: '{}'", dataObjectName);
>                         //logger.warn("tabular.get: '{}'", tabular.get(new Object[] {dataObjectName}).get("value"));
> 
>                         return getPrimitiveAttributeValue(tabular.get(new Object[] {dataObjectName}).get("value"), newFieldNames);
>                 }
> 