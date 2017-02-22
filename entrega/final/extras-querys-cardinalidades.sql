/* QUERIES INVESTIGATIVAS */
set schema 'aa_bd_px_gs_rm';

-- Prova que codigo_programa possui mais de uma funcao_geral
select count(distinct "codigo_programa"),"id_funcao_geral_acao" from pagamentos GROUP BY "id_funcao_geral_acao" order by 1 desc;

-- Porque colocar programa dentro de acao
select count(distinct "codigo_programa"),"codigo_acao" from pagamentos GROUP BY "codigo_acao" order by 1 desc; -- 1 pra n
select count(distinct "Codigo_Acao"),"Codigo_Programa" from raw_data GROUP BY "Codigo_Programa" order by 1 desc; -- mais variações
-- Conclusao: criada tabela programa_acao

-- Orgao superior - orgao subordinado
select count(distinct "Codigo_Orgao_Subordinado"),"Codigo_Orgao_Superior" from raw_data GROUP BY "Codigo_Orgao_Superior" order by 1 desc;

-- Investigando funcao_geral e programa_acao
select count(distinct "id_funcao_geral"),"id_programa_acao" from pagamento GROUP BY "id_programa_acao" order by 1 desc; -- 1 pra n
select count(distinct "Codigo_Acao"),"Codigo_Programa" from raw_data GROUP BY "Codigo_Programa" order by 1 desc; -- mais variações
-- Conclusão: nxn, criação da tabela funcao_geral_programa_acao

select count(distinct "codigo_unidade_gestora"),"id_funcao_geral" from pagamento GROUP BY "id_funcao_geral" order by 1 desc;

select count(*), gestao_pagamento from pagamento group by 2 order by 1 desc;

select count(distinct "codigo_unidade_gestora"),"id_funcao_geral_acao","codigo_programa" from pagamento GROUP BY "id_funcao_geral_acao",id_funcao_geral_acao,codigo_programa order by 1 desc;

select distinct codigo_unidade_gestora,"id_funcao_geral_acao","codigo_programa" from pagamentos order by 1 asc;

select distinct id_funcao_geral_acao,codigo_programa from pagamentos;

select count(distinct "codigo_unidade_gestora"),"id_funcao_geral_programa_acao" from pagamentos GROUP BY "id_funcao_geral_programa_acao" order by 1 desc;

/* FIM QUERIES INVESTIGATIVAS */
