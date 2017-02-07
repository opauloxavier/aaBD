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


select max(length("CPF_Favorecido")) from public.raw_data;

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



BEGIN;

TRUNCATE public.temp_table RESTART IDENTITY;

INSERT INTO public.temp_table (codigo_orgao_superior,codigo_orgao_subordinado,codigo_unidade_gestora,codigo_funcao,codigo_subfuncao,codigo_acao,codigo_programa) 
	SELECT 
		"Codigo_Orgao_Superior" :: Integer, 
		"Codigo_Orgao_Subordinado" :: Integer,
		"Codigo_Unidade_Gestora" :: Integer,
		"Codigo_Funcao" :: Integer,
		"Codigo_Subfuncao" :: Integer,
		"Codigo_Acao",
		"Codigo_Programa" :: Integer
from public.raw_data;

UPDATE temp_table SET "id_favorecido" = (Select distinct "id_favorecido" from public.favorecido,public.raw_data where raw_data."CPF_Favorecido" = "cpf_favorecido" and raw_data."Nome_Favorecido" = "nome_favorecido");

COMMIT;

(Select distinct "id_favorecido" from public.favorecido,public.raw_data where raw_data."CPF_Favorecido" = "cpf_favorecido" and raw_data."Nome_Favorecido" = "nome_favorecido");