
--- QUERIES DO TRABALHO ----

--QUERY 1--

select distinct nome_favorecido from temp_table LEFT JOIN favorecido ON temp_table.id_favorecido = favorecido.id_favorecido where valor_pagamento = (select max(valor_pagamento) from temp_table);

--QUERY 2--

select sum(valor_pagamento::Decimal(10,2)) AS total_gasto_diarias from temp_table
	LEFT JOIN unidade_gestora ON temp_table.codigo_unidade_gestora = unidade_gestora.codigo_unidade_gestora
	LEFT JOIN orgao ON unidade_gestora.id_orgao = orgao.id_orgao
	LEFT JOIN orgao_superior ON orgao.id_orgao_superior = orgao_superior.codigo_orgao_superior

WHERE nome_orgao_superior='MINISTERIO DO PLANEJAMENTO,ORCAMENTO E GESTAO';

--QUERY 3 --

SELECT COUNT(distinct "valor_pagamento") AS numero_pagamentos,temp_table.id_favorecido,favorecido.nome_favorecido from temp_table 
	LEFT JOIN favorecido ON temp_table.id_favorecido = favorecido.id_favorecido 
GROUP BY temp_table.id_favorecido,favorecido.nome_favorecido HAVING count(distinct "valor_pagamento") > 5 order by numero_pagamentos ASC;

--Query 4--

select SUM(temp_table.valor_pagamento::Numeric(10,2)) as soma_diaras, programa.nome_programa from temp_table
	LEFT JOIN funcao_geral_programa_acao ON temp_table.id_funcao_geral_programa_acao = funcao_geral_programa_acao.id_funcao_geral_programa_acao
	LEFT JOIN programa_acao ON funcao_geral_programa_acao.id_programa_acao = programa_acao.id_programa_acao
	LEFT JOIN programa ON programa_acao.codigo_programa = programa.codigo_programa

GROUP BY 2 ORDER BY soma_diaras ASC LIMIT 1;

--Query 5--

Select nome_orgao_superior,nome_orgao_subordinado,nome_unidade_gestora,nome_funcao,nome_subfuncao,nome_programa,nome_acao, AVG(valor_pagamento::Decimal(10,2))::Decimal(10,2) as media_gasta_acoes from temp_table
	LEFT JOIN unidade_gestora ON temp_table.codigo_unidade_gestora = unidade_gestora.codigo_unidade_gestora
	LEFT JOIN orgao ON unidade_gestora.id_orgao = orgao.id_orgao
	LEFT JOIN orgao_superior ON orgao.id_orgao_superior = orgao_superior.codigo_orgao_superior
	LEFT JOIN orgao_subordinado ON orgao.id_orgao_subordinado = orgao_subordinado.codigo_orgao_subordinado
	LEFT JOIN funcao_geral_programa_acao ON temp_table.id_funcao_geral_programa_acao = funcao_geral_programa_acao.id_funcao_geral_programa_acao
	LEFT JOIN funcao_geral ON funcao_geral_programa_acao.id_funcao_geral = funcao_geral.id_funcao_geral
	LEFT JOIN funcao ON funcao_geral.id_funcao = funcao.codigo_funcao
	LEFT JOIN subfuncao ON funcao_geral.id_subfuncao = subfuncao.codigo_subfuncao
	LEFT JOIN programa_acao ON funcao_geral_programa_acao.id_programa_acao = programa_acao.id_programa_acao
	LEFT JOIN programa ON programa_acao.codigo_programa = programa.codigo_programa
	LEFT JOIN acao ON programa_acao.codigo_acao = acao.codigo_acao
	
GROUP BY 1,2,3,4,5,6,7;