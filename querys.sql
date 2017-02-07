create table Orgao_Superior (
	codigo_orgao_superior SERIAL PRIMARY KEY,
	nome_orgao_superior char(45)
);

create table Temp_Table (
	id SERIAL PRIMARY KEY,
	codigo_orgao_superior integer REFERENCES public.codigo_orgao_superior("codigo_orgao_superior"),
	nome_orgao_superior char(45)
);

create table Orgao_Subordinado (
	codigo_orgao_subordinado SERIAL PRIMARY KEY,
	nome_orgao_subordinado char(45)
);

create table Unidade_Gestora (
	codigo_unidade_gestora SERIAL PRIMARY KEY,
	nome_unidade_gestora char(45)
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
	nome_acao char(150)
);

create table favorecido (
	cpf_favorecido char(14) PRIMARY KEY,
	nome_favorecido char(45)
);


select max(length("Nome_Favorecido")) from public.raw_data;

ALTER TABLE public.favorecido ADD COLUMN id SERIAL PRIMARY KEY;


select max(length("Nome_Orgao_Superior")) from public.raw_data;

INSERT INTO public.temp_table (codigo_orgao_superior,nome_orgao_superior) SELECT "Codigo_Orgao_Superior" :: Integer, "Nome_Orgao_Superior" from public.raw_data ORDER BY "Codigo_Orgao_Superior" ASC;

SELECT DISTINCT "Nome_Orgao_Superior","Codigo_Orgao_Superior" from public.raw_data ORDER BY "Codigo_Orgao_Superior" ASC;

select max(length("Nome_Orgao_Subordinado")) from public.raw_data;

select count(*) from public.temp_table;

INSERT INTO public.orgao_subordinado(codigo_orgao_subordinado,nome_orgao_subordinado) SELECT DISTINCT "Codigo_Orgao_Subordinado" :: Integer, "Nome_Orgao_Subordinado" from public.raw_data ORDER BY "Nome_Orgao_Subordinado" ASC;

INSERT INTO public.unidade_gestora (codigo_unidade_gestora,nome_unidade_gestora) SELECT DISTINCT "Codigo_Unidade_Gestora" :: Integer, "Nome_Unidade_Gestora" from public.raw_data ORDER BY "Codigo_Unidade_Gestora" ASC;

INSERT INTO public.funcao(codigo_funcao,nome_funcao) SELECT DISTINCT "Codigo_Funcao" :: Integer, "Nome_Funcao" from public.raw_data ORDER BY "Nome_Funcao" ASC;

INSERT INTO public.subfuncao(codigo_subfuncao,nome_subfuncao) SELECT DISTINCT "Codigo_Subfuncao" :: Integer, "Nome_Subuncao" from public.raw_data ORDER BY "Nome_Subuncao" ASC;

INSERT INTO public.programa(codigo_programa,nome_programa) SELECT DISTINCT "Codigo_Programa" :: Integer, "Nome_Programa" from public.raw_data ORDER BY "Nome_Programa" ASC;

INSERT INTO public.acao(codigo_acao,nome_acao) SELECT DISTINCT "Codigo_Acao", "Nome_Acao" from public.raw_data ORDER BY "Nome_Acao" ASC;

INSERT INTO public.favorecido(cpf_favorecido,nome_favorecido) SELECT DISTINCT "CPF_Favorecido", "Nome_Favorecido" from public.raw_data ORDER BY "Nome_Favorecido" ASC;

/* transaction que adiciona os dados da raw_data na temp table.*/

select distinct "nome_favorecido","cpf_favorecido" from public.favorecido;

select "Linguagem_Cidada","Nome_Acao" from raw_data;

BEGIN;

DROP TABLE temp_table;

CREATE TABLE temp_table
(
  id serial NOT NULL,
  codigo_orgao_superior integer,
  codigo_orgao_subordinado integer,
  codigo_unidade_gestora integer,
  codigo_funcao integer,
  codigo_subfuncao integer,
  codigo_programa integer,
  codigo_acao character(6),
  id_favorecido integer,
  cpf_favorecido character(14),
  nome_favorecido character(45),
  
  CONSTRAINT temp_table_pkey PRIMARY KEY (id),
  CONSTRAINT temp_table_codigo_acao_fkey FOREIGN KEY (codigo_acao)
      REFERENCES acao (codigo_acao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_codigo_funcao FOREIGN KEY (codigo_funcao)
      REFERENCES funcao (codigo_funcao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_codigo_orgao_subordinado FOREIGN KEY (codigo_orgao_subordinado)
      REFERENCES orgao_subordinado (codigo_orgao_subordinado) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_codigo_orgao_superior_fkey FOREIGN KEY (codigo_orgao_superior)
      REFERENCES orgao_superior (codigo_orgao_superior) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_codigo_subfuncao_fkey FOREIGN KEY (codigo_subfuncao)
      REFERENCES subfuncao (codigo_subfuncao) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_codigo_unidade_gestora FOREIGN KEY (codigo_unidade_gestora)
      REFERENCES unidade_gestora (codigo_unidade_gestora) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT temp_table_id_favorecido_fkey FOREIGN KEY (id_favorecido)
      REFERENCES favorecido (id_favorecido) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE programa
  OWNER TO postgres;

CREATE INDEX 
   ON temp_table USING btree (cpf_favorecido ASC NULLS LAST, nome_favorecido ASC NULLS LAST);

CREATE INDEX ON favorecido USING btree (cpf_favorecido ASC NULLS LAST, nome_favorecido ASC NULLS LAST);



INSERT INTO public.temp_table (codigo_orgao_superior,codigo_orgao_subordinado,codigo_unidade_gestora,codigo_funcao,codigo_subfuncao,codigo_acao,codigo_programa,cpf_favorecido,nome_favorecido) 
	SELECT 
		"Codigo_Orgao_Superior" :: Integer, 
		"Codigo_Orgao_Subordinado" :: Integer,
		"Codigo_Unidade_Gestora" :: Integer,
		"Codigo_Funcao" :: Integer,
		"Codigo_Subfuncao" :: Integer,
		"Codigo_Acao",
		"Codigo_Programa" :: Integer,
		"CPF_Favorecido",
		"Nome_Favorecido"
from public.raw_data;

UPDATE temp_table a SET "id_favorecido" = (Select favorecido."id_favorecido" from public.favorecido,public.temp_table where temp_table."cpf_favorecido" = favorecido."cpf_favorecido" and temp_table."nome_favorecido" = favorecido."nome_favorecido" and a.id = temp_table.id);

ALTER TABLE temp_table DROP "cpf_favorecido";
ALTER TABLE temp_table DROP "nome_favorecido";

COMMIT;

(Select distinct "id_favorecido" from public.favorecido,public.raw_data where raw_data."CPF_Favorecido" = "cpf_favorecido" and raw_data."Nome_Favorecido" = "nome_favorecido");
