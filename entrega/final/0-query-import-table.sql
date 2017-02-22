CREATE SCHEMA IF NOT EXISTS aa_bd_px_gs_rm;
set schema 'aa_bd_px_gs_rm';

DROP TABLE IF EXISTS raw_data;

create table IF NOT EXISTS raw_data (
    "Codigo_Orgao_Superior" VARCHAR NOT NULL,
    "Nome_Orgao_Superior" VARCHAR NOT NULL,
    "Codigo_Orgao_Subordinado" VARCHAR NOT NULL,
    "Nome_Orgao_Subordinado" VARCHAR NOT NULL,
    "Codigo_Unidade_Gestora" VARCHAR NOT NULL,
    "Nome_Unidade_Gestora" VARCHAR NOT NULL,
    "Codigo_Funcao" VARCHAR NOT NULL,
    "Nome_Funcao" VARCHAR NOT NULL,
    "Codigo_Subfuncao" VARCHAR NOT NULL,
    "Nome_Subfuncao" VARCHAR NOT NULL,
    "Codigo_Programa" VARCHAR NOT NULL,
    "Nome_Programa" VARCHAR NOT NULL,
    "Codigo_Acao" VARCHAR NOT NULL,
    "Nome_Acao" VARCHAR NOT NULL,
    "Linguagem_Cidada" VARCHAR,
    "CPF_Favorecido" VARCHAR NOT NULL,
    "Nome_Favorecido" VARCHAR NOT NULL,
    "Documento_Pagamento" VARCHAR NOT NULL,
    "Gestao_Pagamento" VARCHAR NOT NULL,
    "Data_Pagamento" VARCHAR NOT NULL,
    "Valor_Pagamento" DOUBLE PRECISION NOT NULL
);

set client_encoding = UTF8;
COPY raw_data from '/home/over/git/aa_BD/entrega/final/201403_Diarias_ORIGINAL-APRESENTACAO.csv' delimiter ',' CSV HEADER;
-- Finalizar importação