# Scripts para ajudar a monitorar o ZABBIX
Todos esses scripts ter�o que estar no server do zabbix no diret�iro: **/usr/lib/zabbix/externalscripts**

Todos esses scripts ter�o que estar com permiss�o de execu��o e o dono (owner) ser o usu�rio **zabbix**
Script:
> chmod +x pje*

> chown zabbix. pje*

--- 

## 1. pjeMonitoramento.py

Respons�vel por realizar a consulta no servi�o de monitora��o do PJe. Esse servi�o se encontra no caminho: .../primeirograu/seam/resource/rest/monitoracao/receita

Obs: � necess�rio configurar o **PROXY**. Abra o arquivo e edite a linha 28 e 29.
Treco de c�digo que necessita ser trocado:
> self._proxies = proxies = {
	  "http": "http://proxy.xxx.xxx.xx:porta",
	  "https": "http://proxy.xxx.xxx.xx:porta",
	}

Exemplo de execu��o: **python pjeMonitoramento.py qualidade.pje.csjt.jus.br primeirograu oab**

Onde:
**qualidade.pje.csjt.jus.br** representa o ambiente.
**oab** representa o servi�o. Os servi�os poss�veis s�o:  receita, oab, banco

---

## 2. pjeDisponibilidadeBDNT.py

Respons�vel por realizar a consulta no servi�o do BNDT.

Exemplo de execu��o: **python pjeDisponibilidadeBDNT.py**

---

## 3. pjeDisponibilidadeOAB.py

Respons�vel por realizar a consulta no servi�o da OAB.

Obs: � necess�rio configurar o **PROXY**. Abra o arquivo e edite a linha 62 e 63.
Treco de c�digo que necessita ser trocado:
> self._proxies = proxies = {
	  "http": "http://proxy.xxx.xxx.xx:porta",
	  "https": "http://proxy.xxx.xxx.xx:porta",
	}

Exemplo de execu��o: **python pjeDisponibilidadeOAB.py**

---

## 4. pjeDisponibilidadeReceita.py

Respons�vel por realizar a consulta no servi�o da Receita Federal.

Obs: � necess�rio configurar o **PROXY**. Abra o arquivo e edite a linha 59 e 60.
Treco de c�digo que necessita ser trocado:
> self._proxies = proxies = {
	  "http": "http://proxy.xxx.xxx.xx:porta",
	  "https": "http://proxy.xxx.xxx.xx:porta",
	}

Exemplo de execu��o: **python pjeDisponibilidadeReceita.py**

---

## 5. pjeDisponibilidadeRegional.py

Respons�vel por realizar a consulta no servi�o do PJe das regionais.

Obs: � necess�rio configurar o **PROXY**. Abra o arquivo e edite a linha 23 e 24.
Treco de c�digo que necessita ser trocado:
> self._proxies = proxies = {
	  "http": "http://proxy.xxx.xxx.xx:porta",
	  "https": "http://proxy.xxx.xxx.xx:porta",
	}

Exemplo de execu��o: **python pjeDisponibilidadeRegional.py pje.trt3.jus.br primeirograu**

Onde: 
**pje.trt3.jus.br** representa o servi�o do PJe da regional
**primeirograu** representa a inst�ncia

---

## 6. zapache

Respons�vel por fazer a consulta ao servi�o do apache

---

## 7. pjeDisponibilidadeAmbienteInterno.py

Respons�vel por realizar a consulta no servi�o do PJe nos ambientes interno.

Exemplo de execu��o: **python pjeDisponibilidadeAmbienteInterno.py avaliacao.pje.csjt.jus.br primeirograu**

Onde: 
**avaliacao.pje.csjt.jus.br** representa o servi�o do PJe
**primeirograu** representa a inst�ncia