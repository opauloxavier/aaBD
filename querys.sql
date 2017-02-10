create table Orgao_Superior (
	codigo_orgao_superior SERIAL PRIMARY KEY,
	nome_orgao_superior char(45)
);

create table Orgao_Subordinado (
	codigo_orgao_subordinado SERIAL PRIMARY KEY,
	nome_orgao_subordinado char(45)
);

create table Unidade_Gestora (
	codigo_unidade_gestora SERIAL PRIMARY KEY,
	nome_unidade_gestora char(45),
	id_orgao integer

	CONSTRAINT table_unidade_gestora_id_orgao_fkey FOREIGN KEY (id_orgao)
		REFERENCES public.orgao (id_orgao) MATCH SIMPLE
);

create table Funcao (
	codigo_funcao SERIAL PRIMARY KEY,
	nome_funcao char(21)
);

create table Subfuncao (
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

create table orgao (
	id_orgao SERIAL PRIMARY KEY,
	id_orgao_superior integer,
	id_orgao_subordinada integer,
	
	CONSTRAINT table_orgao_superior_fkey FOREIGN KEY (id_orgao_superior)
		REFERENCES public.orgao_superior (codigo_orgao_superior) MATCH SIMPLE,
	CONSTRAINT table_orgao_subordinado_fkey FOREIGN KEY (id_orgao_subordinada)
		REFERENCES public.orgao_subordinado (codigo_orgao_subordinado) MATCH SIMPLE
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

create table funcao_geral_acao (
	id_funcao_geral_acao SERIAL PRIMARY KEY,
	id_funcao_geral integer,
	codigo_acao varchar,

	CONSTRAINT table_funcao_geral_acao_funcao_geral_fkey FOREIGN KEY (id_funcao_geral)
		REFERENCES public.funcao_geral (id_funcao_geral) MATCH SIMPLE,
	CONSTRAINT table_funcao_geral_acao_codigo_acao_fkey FOREIGN KEY (codigo_acao)
		REFERENCES public.acao (codigo_acao) MATCH SIMPLE
);


select max(length("Linguagem_Cidada")) from public.raw_data;

ALTER TABLE public.favorecido ADD COLUMN id SERIAL PRIMARY KEY;


select max(length("Nome_Orgao_Superior")) from public.raw_data;

INSERT INTO public.temp_table (codigo_orgao_superior,nome_orgao_superior) SELECT "Codigo_Orgao_Superior" :: Integer, "Nome_Orgao_Superior" from public.raw_data ORDER BY "Codigo_Orgao_Superior" ASC;

SELECT DISTINCT "Nome_Orgao_Superior","Codigo_Orgao_Superior" from public.raw_data ORDER BY "Codigo_Orgao_Superior" ASC;

select max(length("Nome_Orgao_Subordinado")) from public.raw_data;

select count(*) from public.temp_table;

INSERT INTO public.orgao_subordinado(codigo_orgao_subordinado,nome_orgao_subordinado) SELECT DISTINCT "Codigo_Orgao_Subordinado" :: Integer, "Nome_Orgao_Subordinado" from public.raw_data ORDER BY "Nome_Orgao_Subordinado" ASC;

INSERT INTO public.orgao(id_orgao_superior,id_orgao_subordinado) SELECT DISTINCT "Codigo_Orgao_Superior" :: Integer,"Codigo_Orgao_Subordinado" :: Integer from public.raw_data;

INSERT INTO public.unidade_gestora (codigo_unidade_gestora,nome_unidade_gestora) SELECT DISTINCT "Codigo_Unidade_Gestora" :: Integer, "Nome_Unidade_Gestora" from public.raw_data ORDER BY "Codigo_Unidade_Gestora" ASC;

INSERT INTO public.funcao(codigo_funcao,nome_funcao) SELECT DISTINCT "Codigo_Funcao" :: Integer, "Nome_Funcao" from public.raw_data ORDER BY "Nome_Funcao" ASC;

INSERT INTO public.subfuncao(codigo_subfuncao,nome_subfuncao) SELECT DISTINCT "Codigo_Subfuncao" :: Integer, "Nome_Subuncao" from public.raw_data ORDER BY "Nome_Subuncao" ASC;

INSERT INTO public.funcao_geral(id_funcao,id_subfuncao) SELECT DISTINCT "Codigo_Funcao" :: Integer,"Codigo_Subfuncao" :: Integer from public.raw_data;

INSERT INTO public.programa(codigo_programa,nome_programa) SELECT DISTINCT "Codigo_Programa" :: Integer, "Nome_Programa" from public.raw_data ORDER BY "Nome_Programa" ASC;

INSERT INTO public.acao(codigo_acao,nome_acao,linguagem_cidada) SELECT DISTINCT "Codigo_Acao", "Nome_Acao","Linguagem_Cidada" from public.raw_data;

INSERT INTO public.pagamento(documento_pagamento,gestao_pagamento,data_pagamento,valor_pagamento) select "Documento_Pagamento","Gestao_Pagamento","Data_Pagamento","Valor_Pagamento" from public.raw_data; 
/* transaction que adiciona os dados da raw_data na temp table.*/

INSERT INTO public.funcao_geral_acao(id_funcao_geral,codigo_acao) select distinct "id_funcao_geral","codigo_acao" from public.temp_table;
  --

select "Linguagem_Cidada","Nome_Acao" from raw_data;

select distinct "Linguagem_Cidada" from public.raw_data where "Nome_Acao" = 'Segurança Institucional do Presidente da República e do Vice-Presidente da República, Respectivos Familiares, e Outras Autoridades'; 

select distinct "Codigo_Orgao_Subordinado" from public.raw_data;


select distinct "id_funcao_geral" from public.temp_table;

--Prova que ação não tem apenas uma funcao geral
select count(distinct "id_orgao"),"codigo_unidade_gestora" from public.temp_table GROUP BY "codigo_unidade_gestora" order by 1 desc;

-- Prova que codigo_programa possui mais de uma funcao_geral
select count(distinct "codigo_programa"),"id_funcao_geral_acao" from public.temp_table GROUP BY "id_funcao_geral_acao" order by 1 desc;

-- Orgao superior - orgao subordinado
select count(distinct "Codigo_Orgao_Superior"),"Codigo_Orgao_Subordinado" from public.raw_data GROUP BY "Codigo_Orgao_Subordinado" order by 1 desc;

select count(*), gestao_pagamento from temp_table group by 2 order by 1 desc;


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
  id_funcao_geral integer,
  id_funcao_geral_acao integer,
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
  CONSTRAINT temp_table_id_funcao_geral_acao_fkey FOREIGN KEY (id_funcao_geral_acao)
      REFERENCES public.funcao_geral_acao (id_funcao_geral_acao) MATCH SIMPLE
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

UPDATE temp_table a SET "id_favorecido" = (Select favorecido."id_favorecido" from public.favorecido,public.temp_table where temp_table."cpf_favorecido" = favorecido."cpf_favorecido" and temp_table."nome_favorecido" = favorecido."nome_favorecido" and a.id = temp_table.id);

ALTER TABLE temp_table DROP "cpf_favorecido";
ALTER TABLE temp_table DROP "nome_favorecido";

UPDATE temp_table a SET "id_orgao" = (Select orgao."id_orgao" from public.orgao,public.temp_table where temp_table."codigo_orgao_subordinado" = orgao."id_orgao_subordinado" and temp_table."codigo_orgao_superior" = orgao."id_orgao_superior" and a.id = temp_table.id);

ALTER TABLE temp_table DROP "codigo_orgao_subordinado";
ALTER TABLE temp_table DROP "codigo_orgao_superior";

UPDATE temp_table a SET "id_funcao_geral" = (Select funcao_geral."id_funcao_geral" from public.funcao_geral,public.temp_table where temp_table."codigo_funcao" = funcao_geral."id_funcao" and temp_table."codigo_subfuncao" = funcao_geral."id_subfuncao" and a.id = temp_table.id);

ALTER TABLE temp_table DROP "codigo_funcao";
ALTER TABLE temp_table DROP "codigo_subfuncao";

UPDATE temp_table a SET "id_funcao_geral_acao" = (Select funcao_geral_acao."id_funcao_geral_acao" from public.funcao_geral_acao where a.codigo_acao = funcao_geral_acao.codigo_acao and a.id_funcao_geral = funcao_geral_acao.id_funcao_geral);

ALTER TABLE temp_table DROP codigo_acao;
ALTER TABLE temp_table DROP id_funcao_geral;

UPDATE unidade_gestora a set id_orgao = (Select distinct id_orgao from temp_table where temp_table.codigo_unidade_gestora = a.codigo_unidade_gestora);

ALTER TABLE temp_table DROP id_orgao;

);

COMMIT;

END;