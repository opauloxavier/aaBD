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
