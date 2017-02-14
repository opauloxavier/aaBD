-- CRIAÇÃO TABELA ORIGINAL CSV

BEGIN;

create table raw_data_test (
    Codigo_Orgao_Superior VARCHAR NOT NULL,
    Nome_Orgao_Superior VARCHAR NOT NULL,
    Codigo_Orgao_Subordinado VARCHAR NOT NULL,
    Nome_Orgao_Subordinado VARCHAR NOT NULL,
    Codigo_Unidade_Gestora VARCHAR NOT NULL,
    Nome_Unidade_Gestora VARCHAR NOT NULL,
    Codigo_Funcao VARCHAR NOT NULL,
    Nome_Funcao VARCHAR NOT NULL,
    Codigo_Subfuncao VARCHAR NOT NULL,
    Nome_Subfuncao VARCHAR NOT NULL,
    Codigo_Programa VARCHAR NOT NULL,
    Nome_Programa VARCHAR NOT NULL,
    Codigo_Acao VARCHAR NOT NULL,
    Nome_Acao VARCHAR NOT NULL,
    Linguagem_Cidada VARCHAR,
    CPF_Favorecido VARCHAR NOT NULL,
    Nome_Favorecido VARCHAR NOT NULL,
    Documento_Pagamento VARCHAR NOT NULL,
    Gestao_Pagamento VARCHAR NOT NULL,
    Data_Pagamento VARCHAR NOT NULL,
    Valor_Pagamento DOUBLE PRECISION NOT NULL
);
COMMIT;

set client_encoding = LATIN1;
COPY public.raw_data_test from '/home/over/git/aa_BD/201403_Diarias-tratados.csv' delimiter ',' CSV HEADER;
-- Finalizar importação
COMMIT;

END;

create table orgao_Superior (
	codigo_orgao_superior SERIAL PRIMARY KEY,
	nome_orgao_superior char(45)
);

create table orgao_Subordinado (
	codigo_orgao_subordinado SERIAL PRIMARY KEY,
	nome_orgao_subordinado char(45)
);

create table orgao (
	id_orgao SERIAL PRIMARY KEY,
	id_orgao_superior integer,
	id_orgao_subordinada integer,
	
	CONSTRAINT table_orgao_superior_fkey FOREIGN KEY (id_orgao_superior)
		REFERENCES public.orgao_superior (codigo_orgao_superior) MATCH SIMPLE,
	CONSTRAINT table_orgao_subordinado_fkey FOREIGN KEY (id_orgao_subordinada)
		REFERENCES public.orgao_subordinado (codigo_orgao_subordinado) MATCH SIMPLE
);

create table unidade_gestora (
	codigo_unidade_gestora SERIAL PRIMARY KEY,
	nome_unidade_gestora char(45),
	id_orgao integer

	CONSTRAINT table_unidade_gestora_id_orgao_fkey FOREIGN KEY (id_orgao)
		REFERENCES public.orgao (id_orgao) MATCH SIMPLE
);

create table funcao (
	codigo_funcao SERIAL PRIMARY KEY,
	nome_funcao char(21)
);

create table subfuncao (
	codigo_subfuncao SERIAL PRIMARY KEY,
	nome_subfuncao char(48)
);

create table programa (
	codigo_programa SERIAL PRIMARY KEY,
	nome_programa char(110)
);

create table acao (
	codigo_acao char(6) PRIMARY KEY,
	nome_acao char(150),
	linguagem_cidada char(76)
);

create table favorecido (
	id_favorecido SERIAL PRIMARY KEY,
	cpf_favorecido char(14) PRIMARY KEY,
	nome_favorecido char(45)
);

create table pagamento (
	id_pagamento SERIAL PRIMARY KEY,
	documento_pagamento varchar,
	gestao_pagamento varchar,
	data_pagamento varchar,
	valor_pagamento varchar
);

create table funcao_geral (
	id_funcao_geral SERIAL PRIMARY KEY,
	id_funcao integer,
	id_subfuncao integer,
	
	CONSTRAINT table_funcao_fkey FOREIGN KEY (id_funcao)
		REFERENCES public.funcao (codigo_funcao) MATCH SIMPLE,
	CONSTRAINT table_subfuncao_fkey FOREIGN KEY (id_subfuncao)
		REFERENCES public.subfuncao (codigo_subfuncao) MATCH SIMPLE
);

create table programa_acao (
	id_programa_acao SERIAL PRIMARY KEY,
	codigo_acao varchar,
	codigo_programa integer,

	CONSTRAINT table_programa_acao_acao_fkey FOREIGN KEY (codigo_acao)
		REFERENCES public.acao (codigo_acao) MATCH SIMPLE,
	CONSTRAINT table_programa_acao_programa_programa_fkey FOREIGN KEY (codigo_programa)
		REFERENCES public.programa (codigo_programa) MATCH SIMPLE
);

create table funcao_geral_programa_acao (
	id_funcao_geral_programa_acao SERIAL PRIMARY KEY,
	id_funcao_geral integer,
	id_programa_acao integer,

	CONSTRAINT table_funcao_geral_programa_acao_id_funcao_geral_fkey FOREIGN KEY (id_funcao_geral)
		REFERENCES public.funcao_geral (id_funcao_geral) MATCH SIMPLE,
	CONSTRAINT table_funcao_geral_programa_acao_id_programa_acao_fkey FOREIGN KEY (id_programa_acao)
		REFERENCES public.programa_acao (id_programa_acao) MATCH SIMPLE
);

/* QUERIES DE INSERÇÃO NAS TABELAS */

INSERT INTO public.orgao_superior (codigo_orgao_superior,nome_orgao_superior) SELECT "Codigo_Orgao_Superior" :: Integer, "Nome_Orgao_Superior" from public.raw_data ORDER BY "Codigo_Orgao_Superior" ASC;

INSERT INTO public.orgao_subordinado(codigo_orgao_subordinado,nome_orgao_subordinado) SELECT DISTINCT "Codigo_Orgao_Subordinado" :: Integer, "Nome_Orgao_Subordinado" from public.raw_data ORDER BY "Nome_Orgao_Subordinado" ASC;

INSERT INTO public.orgao(id_orgao_superior,id_orgao_subordinado) SELECT DISTINCT "Codigo_Orgao_Superior" :: Integer,"Codigo_Orgao_Subordinado" :: Integer from public.raw_data;

INSERT INTO public.unidade_gestora (codigo_unidade_gestora,nome_unidade_gestora) SELECT DISTINCT "Codigo_Unidade_Gestora" :: Integer, "Nome_Unidade_Gestora" from public.raw_data ORDER BY "Codigo_Unidade_Gestora" ASC;

INSERT INTO public.funcao(codigo_funcao,nome_funcao) SELECT DISTINCT "Codigo_Funcao" :: Integer, "Nome_Funcao" from public.raw_data ORDER BY "Nome_Funcao" ASC;

INSERT INTO public.subfuncao(codigo_subfuncao,nome_subfuncao) SELECT DISTINCT "Codigo_Subfuncao" :: Integer, "Nome_Subfuncao" from public.raw_data ORDER BY "Nome_Subuncao" ASC;

INSERT INTO public.funcao_geral(id_funcao,id_subfuncao) SELECT DISTINCT "Codigo_Funcao" :: Integer,"Codigo_Subfuncao" :: Integer from public.raw_data;

INSERT INTO public.programa(codigo_programa,nome_programa) SELECT DISTINCT "Codigo_Programa" :: Integer, "Nome_Programa" from public.raw_data ORDER BY "Nome_Programa" ASC;

INSERT INTO public.acao(codigo_acao,nome_acao,linguagem_cidada) SELECT DISTINCT "Codigo_Acao", "Nome_Acao","Linguagem_Cidada" from public.raw_data;

INSERT INTO programa_acao (codigo_programa,codigo_acao) select distinct "Codigo_Programa","Codigo_Acao" from public.raw_data;

INSERT INTO favorecido (cpf_favorecido,nome_favorecido) select distinct "CPF_Favorecido","Nome_Favorecido" from public.raw_data;

/* FIM QUERIES DE INSERÇÃO NAS TABELAS */


/* QUERIES INVESTIGATIVAS */
select "Linguagem_Cidada","Nome_Acao" from raw_data;

select distinct "Linguagem_Cidada" from public.raw_data where "Nome_Acao" = 'Segurança Institucional do Presidente da República e do Vice-Presidente da República, Respectivos Familiares, e Outras Autoridades'; 

select distinct "Nome_Funcao" from raw_data order by "Nome_Funcao" asc;

select distinct "id_funcao_geral" from public.temp_table;

--Prova que ação não tem apenas uma funcao geral
select count(distinct "id_orgao"),"codigo_unidade_gestora" from public.temp_table GROUP BY "codigo_unidade_gestora" order by 1 desc;
-- Conclusao: inserida coluna id_orgao em "unidade_gestora"

-- Prova que codigo_programa possui mais de uma funcao_geral
select count(distinct "codigo_programa"),"id_funcao_geral_acao" from public.temp_table GROUP BY "id_funcao_geral_acao" order by 1 desc;

-- Porque colocar programa dentro de acao
select count(distinct "codigo_programa"),"codigo_acao" from temp_table GROUP BY "codigo_acao" order by 1 desc; -- quase 1 pra 1
select count(distinct "Codigo_Acao"),"Codigo_Programa" from public.raw_data GROUP BY "Codigo_Programa" order by 1 desc; -- mais variações
-- Conclusao: criada tabela programa_acao

-- Orgao superior - orgao subordinado
select count(distinct "Codigo_Orgao_Subordinado"),"Codigo_Orgao_Superior" from public.raw_data GROUP BY "Codigo_Orgao_Superior" order by 1 desc;

-- Investigando funcao_geral e programa_acao
select count(distinct "id_funcao_geral"),"id_programa_acao" from temp_table GROUP BY "id_programa_acao" order by 1 desc; -- quase 1 pra 1
select count(distinct "Codigo_Acao"),"Codigo_Programa" from public.raw_data GROUP BY "Codigo_Programa" order by 1 desc; -- mais variações
-- Conclusão: 

select count(distinct "codigo_unidade_gestora"),"id_funcao_geral" from temp_table GROUP BY "id_funcao_geral" order by 1 desc;


select count(*), gestao_pagamento from temp_table group by 2 order by 1 desc;

select count(distinct "codigo_unidade_gestora"),"id_funcao_geral_acao","codigo_programa" from public.temp_table GROUP BY "id_funcao_geral_acao",id_funcao_geral_acao,codigo_programa order by 1 desc;

select distinct codigo_unidade_gestora,"id_funcao_geral_acao","codigo_programa" from temp_table order by 1 asc;

select distinct id_funcao_geral_acao,codigo_programa from temp_table;

select count(distinct "codigo_unidade_gestora"),"id_funcao_geral_programa_acao" from public.temp_table GROUP BY "id_funcao_geral_programa_acao" order by 1 desc;


/* FIM QUERIES INVESTIGATIVAS */

BEGIN;

DROP TABLE temp_table;

CREATE TABLE public.temp_table
(
  id SERIAL PRIMARY KEY,
  id_orgao integer,
  codigo_unidade_gestora integer,
  codigo_orgao_superior integer,
  codigo_orgao_subordinado integer,
  codigo_funcao integer,
  codigo_subfuncao integer,
  id_funcao_geral_programa_acao integer,
  id_funcao_geral integer,
  id_programa_acao integer,
  codigo_programa integer,
  codigo_acao character(6),
  id_favorecido integer,
  cpf_favorecido character varying,
  nome_favorecido character varying,
  documento_pagamento character varying,
  gestao_pagamento character varying,
  data_pagamento character varying,
  valor_pagamento character varying,
  
  CONSTRAINT temp_table_codigo_acao_fkey FOREIGN KEY (codigo_acao)
      REFERENCES public.acao (codigo_acao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_codigo_funcao FOREIGN KEY (codigo_funcao)
      REFERENCES public.funcao (codigo_funcao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_id_orgao FOREIGN KEY (id_orgao)
      REFERENCES public.orgao (id_orgao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_codigo_subfuncao_fkey FOREIGN KEY (codigo_subfuncao)
      REFERENCES public.subfuncao (codigo_subfuncao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_funcao_geral_fkey FOREIGN KEY (id_funcao_geral)
      REFERENCES public.funcao_geral (id_funcao_geral) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_codigo_unidade_gestora FOREIGN KEY (codigo_unidade_gestora)
      REFERENCES public.unidade_gestora (codigo_unidade_gestora) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_id_favorecido_fkey FOREIGN KEY (id_favorecido)
      REFERENCES public.favorecido (id_favorecido) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_id_programa_acao_fkey FOREIGN KEY (id_programa_acao)
      REFERENCES public.programa_acao (id_programa_acao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_id_funcao_geral_programa_acao_fkey FOREIGN KEY (id_funcao_geral_programa_acao)
      REFERENCES public.funcao_geral_programa_acao (id_funcao_geral_programa_acao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.temp_table
  OWNER TO postgres;

CREATE INDEX 
   ON temp_table USING btree (cpf_favorecido ASC NULLS LAST, nome_favorecido ASC NULLS LAST);

CREATE INDEX ON favorecido USING btree (cpf_favorecido ASC NULLS LAST, nome_favorecido ASC NULLS LAST);

INSERT INTO public.temp_table (codigo_orgao_subordinado,codigo_orgao_superior,codigo_unidade_gestora,codigo_funcao,codigo_subfuncao,codigo_acao,codigo_programa,cpf_favorecido,nome_favorecido,documento_pagamento,gestao_pagamento,data_pagamento,valor_pagamento)
	SELECT 
		"Codigo_Orgao_Subordinado" ::Integer,
		"Codigo_Orgao_Superior" :: Integer,
		"Codigo_Unidade_Gestora" :: Integer,
		"Codigo_Funcao" :: Integer,
		"Codigo_Subfuncao" :: Integer,
		"Codigo_Acao",
		"Codigo_Programa" :: Integer,
		"CPF_Favorecido",
		"Nome_Favorecido",
		"Documento_Pagamento",
		"Gestao_Pagamento",
		"Data_Pagamento",
		"Valor_Pagamento"
		
from public.raw_data;

-- Ajustando , para ponto e convertendo o data_type para float para poder utilizar nas querys futuras
UPDATE temp_table SET valor_pagamento = replace(valor_pagamento, ',', '.');
ALTER TABLE temp_table ALTER COLUMN valor_pagamento TYPE real USING valor_pagamento::real;
-- Finalizando ajuste de data_type

-- Elaborando Favorecidos
UPDATE temp_table a SET "id_favorecido" = (Select favorecido."id_favorecido" from public.favorecido,public.temp_table where temp_table."cpf_favorecido" = favorecido."cpf_favorecido" and temp_table."nome_favorecido" = favorecido."nome_favorecido" and a.id = temp_table.id);
ALTER TABLE temp_table DROP "cpf_favorecido";
ALTER TABLE temp_table DROP "nome_favorecido";
-- Finalizando Favorecidos


-------------ORGAO -------------------------
-- Estabelecendo orgao
UPDATE temp_table a SET "id_orgao" = (Select orgao."id_orgao" from public.orgao,public.temp_table where temp_table."codigo_orgao_subordinado" = orgao."id_orgao_subordinado" and temp_table."codigo_orgao_superior" = orgao."id_orgao_superior" and a.id = temp_table.id);
ALTER TABLE temp_table DROP "codigo_orgao_subordinado";
ALTER TABLE temp_table DROP "codigo_orgao_superior";
-- preenche a tabela unidade_gestora com o id do orgao
UPDATE unidade_gestora a set id_orgao = (Select distinct id_orgao from temp_table where temp_table.codigo_unidade_gestora = a.codigo_unidade_gestora);
ALTER TABLE temp_table DROP id_orgao;
-- Finalizando orgao
---------------------------------------------

------------FUNCAO_GERAL_PROGRAMA_ACAO ---------------------
--Estabelecendo funcao_geral
UPDATE temp_table a SET "id_funcao_geral" = (Select funcao_geral."id_funcao_geral" from public.funcao_geral,public.temp_table where temp_table."codigo_funcao" = funcao_geral."id_funcao" and temp_table."codigo_subfuncao" = funcao_geral."id_subfuncao" and a.id = temp_table.id);
ALTER TABLE temp_table DROP "codigo_funcao";
ALTER TABLE temp_table DROP "codigo_subfuncao";
-- Finalizando funcao_geral


UPDATE temp_table a SET "id_programa_acao" = (Select programa_acao."id_programa_acao" from public.programa_acao where a.codigo_acao = programa_acao.codigo_acao and a.codigo_programa = programa_acao.codigo_programa);
ALTER TABLE temp_table DROP codigo_acao;
ALTER TABLE temp_table DROP codigo_programa;

--Preenche a tabela funcao_geral_programa_acao
INSERT INTO funcao_geral_programa_acao (id_funcao_geral,id_programa_acao) select distinct "id_funcao_geral","id_programa_acao" from temp_table;

------------FUNCAO_GERAL_PROGRAMA_ACAO ---------------------

UPDATE temp_table a SET "id_funcao_geral_programa_acao" = (Select funcao_geral_programa_acao."id_funcao_geral_programa_acao" from public.funcao_geral_programa_acao where a.id_funcao_geral = funcao_geral_programa_acao.id_funcao_geral and a.id_programa_acao = funcao_geral_programa_acao.id_programa_acao);
ALTER TABLE temp_table DROP id_funcao_geral;
ALTER TABLE temp_table DROP id_programa_acao;

COMMIT;

END;


select count(distinct "id_funcao_geral"),"id_programa_acao" from temp_table GROUP BY "id_programa_acao" order by 1 desc; -- quase 1 pra 1

select * from temp_table where valor_pagamento = 95244 ;


--- QUERIES DO TRABALHO ----

--QUERY 1--

select distinct nome_favorecido from temp_table LEFT JOIN favorecido ON temp_table.id_favorecido = favorecido.id_favorecido where valor_pagamento = (select max(valor_pagamento) from temp_table);

--QUERY 2--

select sum(valor_pagamento)::Decimal(10,2) AS total_gasto_diarias from temp_table
	LEFT JOIN unidade_gestora ON temp_table.codigo_unidade_gestora = unidade_gestora.codigo_unidade_gestora
	LEFT JOIN orgao ON unidade_gestora.id_orgao = orgao.id_orgao
	LEFT JOIN orgao_superior ON orgao.id_orgao_superior = orgao_superior.codigo_orgao_superior

WHERE nome_orgao_superior='MINISTERIO DO PLANEJAMENTO,ORCAMENTO E GESTAO';

--QUERY 3 --

select id_favorecido from temp_table where (select count(id_favorecido) from temp_table)


-------Demonstrações queries ----

--query 2
select temp_table.codigo_unidade_gestora, nome_unidade_gestora, valor_pagamento, unidade_gestora.id_orgao, orgao.id_orgao_superior, orgao_superior.nome_orgao_superior from temp_table
	LEFT JOIN unidade_gestora ON temp_table.codigo_unidade_gestora = unidade_gestora.codigo_unidade_gestora
	LEFT JOIN orgao ON unidade_gestora.id_orgao = orgao.id_orgao
	LEFT JOIN orgao_superior ON orgao.id_orgao_superior = orgao_superior.codigo_orgao_superior

WHERE nome_orgao_superior='MINISTERIO DO PLANEJAMENTO,ORCAMENTO E GESTAO';
