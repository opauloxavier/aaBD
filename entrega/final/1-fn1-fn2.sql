-- Ajustando para FN1
CREATE SCHEMA IF NOT EXISTS fn1;
set schema 'fn1';

CREATE TABLE IF NOT EXISTS FN1 AS SELECT * FROM aa_bd_px_gs_rm.raw_data;
ALTER TABLE fn1 ADD COLUMN id SERIAL PRIMARY KEY;

-- Ajustando para FN2
CREATE SCHEMA IF NOT EXISTS fn2;
set schema 'fn2';

CREATE TABLE IF NOT EXISTS raw_data AS SELECT * FROM aa_bd_px_gs_rm.raw_data;

create table orgao_superior (
	codigo_orgao_superior varchar PRIMARY KEY,
	nome_orgao_superior varchar
);

create table orgao_subordinado (
	codigo_orgao_subordinado varchar PRIMARY KEY,
	nome_orgao_subordinado varchar
);

create table unidade_gestora (
	codigo_unidade_gestora varchar PRIMARY KEY,
	nome_unidade_gestora varchar
);

create table funcao (
	codigo_funcao varchar PRIMARY KEY,
	nome_funcao varchar
);

create table subfuncao (
	codigo_subfuncao varchar PRIMARY KEY,
	nome_subfuncao varchar
);

create table programa (
	codigo_programa varchar PRIMARY KEY,
	nome_programa varchar
);

create table acao (
	codigo_acao varchar PRIMARY KEY,
	nome_acao varchar
);

INSERT INTO orgao_superior (codigo_orgao_superior,nome_orgao_superior) SELECT DISTINCT "Codigo_Orgao_Superior", "Nome_Orgao_Superior" from raw_data ORDER BY "Codigo_Orgao_Superior" ASC;

INSERT INTO orgao_subordinado(codigo_orgao_subordinado,nome_orgao_subordinado) SELECT DISTINCT  "Codigo_Orgao_Subordinado", "Nome_Orgao_Subordinado" from raw_data ORDER BY "Nome_Orgao_Subordinado" ASC;

INSERT INTO unidade_gestora (codigo_unidade_gestora,nome_unidade_gestora) SELECT DISTINCT "Codigo_Unidade_Gestora", "Nome_Unidade_Gestora" from raw_data ORDER BY "Codigo_Unidade_Gestora" ASC;

INSERT INTO funcao(codigo_funcao,nome_funcao) SELECT DISTINCT "Codigo_Funcao", "Nome_Funcao" from raw_data ORDER BY "Nome_Funcao" ASC;

INSERT INTO subfuncao(codigo_subfuncao,nome_subfuncao) SELECT DISTINCT "Codigo_Subfuncao", "Nome_Subfuncao" from raw_data ORDER BY "Nome_Subfuncao" ASC;

INSERT INTO programa(codigo_programa,nome_programa) SELECT DISTINCT "Codigo_Programa", "Nome_Programa" from raw_data ORDER BY "Nome_Programa" ASC;

INSERT INTO acao(codigo_acao,nome_acao) SELECT DISTINCT "Codigo_Acao", "Nome_Acao" from raw_data;

CREATE TABLE pagamentos
(
  id SERIAL PRIMARY KEY,
  codigo_orgao_superior varchar,
  codigo_orgao_subordinado varchar,
  codigo_unidade_gestora varchar,
  codigo_funcao varchar,
  codigo_subfuncao varchar,
  codigo_programa varchar,
  codigo_acao varchar,
  cpf_favorecido varchar,
  nome_favorecido varchar,
  linguagem_cidada varchar,
  documento_pagamento varchar,
  gestao_pagamento varchar,
  data_pagamento varchar,
  valor_pagamento numeric(10,2),

  CONSTRAINT pagamentos_codigo_orgao_superior FOREIGN KEY (codigo_orgao_superior)
      REFERENCES orgao_superior (codigo_orgao_superior) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pagamentos_orgao_subordinado FOREIGN KEY (codigo_orgao_subordinado)
      REFERENCES orgao_subordinado (codigo_orgao_subordinado) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pagamentos_codigo_acao_fkey FOREIGN KEY (codigo_acao)
      REFERENCES acao (codigo_acao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pagamentos_codigo_funcao FOREIGN KEY (codigo_funcao)
      REFERENCES funcao (codigo_funcao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pagamentos_codigo_subfuncao_fkey FOREIGN KEY (codigo_subfuncao)
      REFERENCES subfuncao (codigo_subfuncao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pagamentos_codigo_unidade_gestora FOREIGN KEY (codigo_unidade_gestora)
      REFERENCES unidade_gestora (codigo_unidade_gestora) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE pagamentos
  OWNER TO postgres;

INSERT INTO pagamentos (codigo_orgao_superior,codigo_orgao_subordinado,codigo_unidade_gestora,codigo_funcao,codigo_subfuncao,codigo_acao,codigo_programa,cpf_favorecido,nome_favorecido,linguagem_cidada,documento_pagamento,gestao_pagamento,data_pagamento,valor_pagamento)
	SELECT 
		"Codigo_Orgao_Superior",
		"Codigo_Orgao_Subordinado",
		"Codigo_Unidade_Gestora" ,
		"Codigo_Funcao",
		"Codigo_Subfuncao",
		"Codigo_Acao",
		"Codigo_Programa",
		"CPF_Favorecido",
		"Nome_Favorecido",
		"Linguagem_Cidada",
		"Documento_Pagamento",
		"Gestao_Pagamento",
		"Data_Pagamento",
		"Valor_Pagamento"
from raw_data;