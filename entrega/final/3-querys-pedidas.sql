--- QUERIES DO TRABALHO ----
set schema 'aa_bd_px_gs_rm';

--QUERY 1--

select nome_favorecido,valor_pagamento from pagamentos LEFT JOIN favorecido ON pagamentos.id_favorecido = favorecido.id_favorecido where valor_pagamento = (select max(valor_pagamento) from pagamentos);

--QUERY 2--

select sum(valor_pagamento) AS total_gasto_diarias from pagamentos
	LEFT JOIN unidade_gestora ON pagamentos.codigo_unidade_gestora = unidade_gestora.codigo_unidade_gestora
	LEFT JOIN orgao_subordinado ON unidade_gestora.codigo_orgao_subordinado = orgao_subordinado.codigo_orgao_subordinado
	LEFT JOIN orgao_superior ON orgao_subordinado.codigo_orgao_superior = orgao_superior.codigo_orgao_superior

WHERE nome_orgao_superior='MINISTERIO DO PLANEJAMENTO.ORCAMENTO E GESTAO';

--QUERY 3 --

SELECT COUNT("valor_pagamento") AS numero_pagamentos,pagamentos.id_favorecido,favorecido.nome_favorecido from pagamentos 
	LEFT JOIN favorecido ON pagamentos.id_favorecido = favorecido.id_favorecido 
GROUP BY pagamentos.id_favorecido,favorecido.nome_favorecido HAVING count("valor_pagamento") > 5 order by numero_pagamentos DESC;

--Query 4--

select SUM(pagamentos.valor_pagamento) as soma_diarias, programa.nome_programa from pagamentos
	LEFT JOIN funcao_geral_programa_acao ON pagamentos.id_funcao_geral_programa_acao = funcao_geral_programa_acao.id_funcao_geral_programa_acao
	LEFT JOIN programa_acao ON funcao_geral_programa_acao.id_programa_acao = programa_acao.id_programa_acao
	LEFT JOIN programa ON programa_acao.codigo_programa = programa.codigo_programa

GROUP BY 2 ORDER BY soma_diarias ASC LIMIT 1;

--Query 5--

Select nome_orgao_superior,nome_orgao_subordinado,nome_unidade_gestora,nome_funcao,nome_subfuncao,nome_programa,nome_acao, AVG(valor_pagamento)::Decimal(10,2) as media_gasta_acoes from pagamentos
	LEFT JOIN unidade_gestora ON pagamentos.codigo_unidade_gestora = unidade_gestora.codigo_unidade_gestora
	LEFT JOIN orgao_subordinado ON unidade_gestora.codigo_orgao_subordinado = orgao_subordinado.codigo_orgao_subordinado
	LEFT JOIN orgao_superior ON orgao_subordinado.codigo_orgao_superior = orgao_superior.codigo_orgao_superior
	LEFT JOIN funcao_geral_programa_acao ON pagamentos.id_funcao_geral_programa_acao = funcao_geral_programa_acao.id_funcao_geral_programa_acao
	LEFT JOIN funcao_geral ON funcao_geral_programa_acao.id_funcao_geral = funcao_geral.id_funcao_geral
	LEFT JOIN funcao ON funcao_geral.id_funcao = funcao.codigo_funcao
	LEFT JOIN subfuncao ON funcao_geral.id_subfuncao = subfuncao.codigo_subfuncao
	LEFT JOIN programa_acao ON funcao_geral_programa_acao.id_programa_acao = programa_acao.id_programa_acao
	LEFT JOIN programa ON programa_acao.codigo_programa = programa.codigo_programa
	LEFT JOIN acao ON programa_acao.codigo_acao = acao.codigo_acao
	
GROUP BY 1,2,3,4,5,6,7 order by media_gasta_acoes DESC;