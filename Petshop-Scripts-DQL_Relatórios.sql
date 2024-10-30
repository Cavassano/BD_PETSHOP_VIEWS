/* Relatório 1 - Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31, trazendo as colunas 
(Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), 
ordenado por data de admissão decrescente; */

select 
    emp.nome "Nome do Empregado", emp.cpf "CPF do Empregado", 
	date_format(emp.dataAdm, '%d/%m/%Y') "Data de Admissão do Empregado", 
    concat("R$  ", format(emp.salario, 2, 'de_DE')) "Salário do Empregado",
    emp.departamento_iddepartamento "Departamento do Empregado", tel.numero "Telefone do Empregado"
from empregado emp
	left join telefone tel on tel.empregado_cpf = emp.cpf
		where emp.dataAdm between '2019-01-01' and '2022-03-31'
order by emp.dataAdm desc;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 2 - Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop, trazendo
as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado
por nome do empregado; */

select 
    emp.nome "Nome do Empregado", emp.cpf "CPF do Empregado", 
	date_format(emp.dataAdm, '%d/%m/%Y') "Data de Admissão do Empregado", 
	concat("R$  ", format(emp.salario, 2, 'de_DE')) "Salário do Empregado", 
    emp.departamento_iddepartamento "Departamento do Empregado",
    coalesce(tel.numero, "Não Possui Telefone") "Telefone do Empregado"
from empregado emp
	left join telefone tel on tel.empregado_cpf = emp.cpf
		where emp.salario < (select avg(salario) from empregado)
order by emp.nome asc;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 3 - Lista dos departamentos com a quantidade de empregados total por cada departamento, trazendo
também a média salarial dos funcionários do departamento e a média de comissão recebida pelos empregados do
departamento, com as colunas (Departamento, Quantidade de Empregados, Média Salarial, Média da Comissão),
ordenado por nome do departamento; */

select 
    dep.nome "Nome do Departamento", 
	count(emp.cpf) "Quantidade de Empregados", 
	concat("R$  ", format(avg(emp.salario), 2, 'de_DE')) "Média Salarial dos Empregados", 
	concat("R$  ", format(avg(emp.comissao), 2, 'de_DE')) "Média da Comissão dos Empregados"
from departamento dep
	inner join empregado emp on emp.departamento_iddepartamento = dep.iddepartamento
		group by dep.nome
order by dep.nome asc;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 4 - Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, além da soma
do valor total das vendas do empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF
Empregado, Sexo, Salário, Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas), ordenado por
quantidade total de vendas realizadas; */

select 
    emp.nome "Nome do Empregado", emp.cpf "CPF do Empregado", emp.sexo "Sexo do Empregado", 
		concat("R$  ", format(emp.salario, 2, 'de_DE')) "Salário do Empregado", 
		count(vnd.idvenda) "Quantidade de Vendas do Empregado", 
		concat("R$  ", format(sum(vnd.valor), 2, 'de_DE')) "Valor Total Vendido pelo Empregado", 
		concat("R$  ", format(sum(vnd.comissao), 2, 'de_DE')) "Valor Total da Comissão do Empregado"
from empregado emp
	inner join venda vnd on vnd.empregado_cpf = emp.cpf
		group by emp.nome, emp.cpf, emp.sexo, emp.salario
order by count(vnd.idvenda) asc;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 5 - Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas
realizadas com serviço por cada Empregado, além da soma do valor total apurado pelos serviços prestados nas
vendas por empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo,
Salário, Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comissão das Vendas com Serviço),
ordenado por quantidade total de vendas realizadas; */

select 
    emp.nome "Nome do Empregado", emp.cpf "CPF do Empregado", emp.sexo "Sexo do Empregado", 
		format(emp.salario, 2, 'de_DE') "Salário do Empregado",
		count(its.venda_idvenda) "Quantidade de Vendas com Serviço",
		format(sum(vnd.valor), 2, 'de_DE') "Total do Valor Vendido com Serviço", 
		format(sum(vnd.comissao), 2, 'de_DE') "Total da Comissão das Vendas com Serviço"
from venda vnd
	inner join itensservico its on its.venda_idvenda = vnd.idvenda
	inner join empregado emp on emp.cpf = its.empregado_cpf
		group by emp.nome, emp.cpf, emp.sexo, emp.salario
order by count(its.venda_idvenda) asc;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 6 - Lista dos serviços já realizados por um Pet, trazendo as colunas (Nome do Pet, Data do Serviço,
Nome do Serviço, Quantidade, Valor, Empregado que realizou o Serviço), ordenado por data do serviço da mais
recente a mais antiga; */

select 
    pt.nome "Nome do Pet", vnd.data "Data do Serviço", serv.nome "Nome do Serviço",
    count(its.quantidade) "Quantidade de Serviços",
    concat("R$  ", sum(its.valor)) "Valor Total dos Serviços",
    emp.nome "Empregado que Realizou o Serviço"
from itensservico its
	inner join pet pt on pt.idpet = its.pet_idpet
	inner join servico serv on serv.idservico = its.servico_idservico
	inner join venda vnd on vnd.idvenda = its.venda_idvenda
	inner join empregado emp on emp.cpf = its.empregado_cpf
		group by pt.nome, its.pet_idpet, serv.nome, vnd.data, emp.nome
order by vnd.data desc;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 7 - Lista das vendas já realizados para um Cliente, trazendo as colunas (Data da Venda, Valor, Desconto, Valor
Final, Empregado que realizou a venda), ordenado por data do serviço da mais recente a mais antiga; */

select
    vnd.data "Data da Venda",
    concat("R$ ", format(vnd.valor, 2, 'pt_BR')) "Valor da Venda",
    concat("R$ ", format(vnd.desconto, 2, 'pt_BR')) "Valor do Desconto",
    concat("R$ ", format(vnd.valor - coalesce(vnd.desconto, 0), 2, 'pt_BR')) "Valor Total",
    emp.nome "Nome do Empregado"
from petshop.venda vnd
	inner join empregado emp on emp.cpf = vnd.empregado_cpf
order by vnd.data desc;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 8 - Lista dos 10 serviços mais vendidos, trazendo a quantidade vendas cada serviço, o somatório total
dos valores de serviço vendido, trazendo as colunas (Nome do Serviço, Quantidade Vendas, Total Valor Vendido),
ordenado por quantidade total de vendas realizadas; */

select 
    serv.nome "Nome do Serviço",
    count(vnd.idVenda) "Quantidade Vendas",
    concat("R$  ", SUM(vnd.valor)) "Total Valor Vendido"
from servico serv
	inner join itensservico itserv on serv.idServico = itserv.Servico_idServico
	inner join venda vnd on itserv.Venda_idVenda = vnd.idVenda
	group by serv.nome
order by count(vnd.idVenda) asc
limit 10;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 9 - Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de
pagamento já foi relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido),
ordenado por quantidade total de vendas realizadas; */

select 
    fpag.tipo "Forma de Pagamento",
    count(vnd.idVenda) "Quantidade Vendas",
    concat("R$  ", format(SUM(fpag.valorPago), 2, 'de_DE')) "Valor Total Vendido"
from FormaPgVenda fpag
	inner join Venda vnd on fpag.venda_idVenda = vnd.idVenda
	group by fpag.tipo
order by COUNT(vnd.idVenda) asc;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 10 - Balaço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas (Data Venda,
Quantidade de Vendas, Valor Total Venda), ordenado por Data Venda da mais recente a mais antiga; */

select 
    date(vnd.data) "Data da Venda",
    count(vnd.idVenda) "Quantidade de Vendas",
    concat("R$  ", format(SUM(vnd.valor), 2, 'de_DE')) "Valor Total das Vendas"
from Venda vnd
	group by date(vnd.data)
order by date(vnd.data) DESC;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 11 - Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas (Nome Produto, Valor
Produto, Categoria do Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), ordenado por Nome Produto; */

SELECT
    prod.nome "Nome do Produto",
    concat("R$  ", format(prod.valorVenda, 2, 'de_DE')) "Valor do Produto",
    prod.marca "Categoria do Produto",
    forn.nome "Nome do Fornecedor", forn.email "Email do Fornecedor",
    coalesce(tel.numero, "Telefone Não informado") "Telefone do Fornecedor"
from produtos prod
    inner join itenscompra itcomp on itcomp.produtos_idProduto = prod.idProduto
    inner join compras cmp on cmp.idCompra = itcomp.Compras_idCompra
    inner join fornecedor forn on forn.cpf_cnpj = cmp.Fornecedor_cpf_cnpj
    left join telefone tel on tel.Fornecedor_cpf_cnpj = forn.cpf_cnpj
order by prod.nome asc;

-- ______________________________________________________________________________________________________________________________________

/* Relatório 12 - Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou
em vendas e o total de valor apurado com a venda do produto, trazendo as colunas (Nome Produto, Quantidade (Total) Vendas,
Valor Total Recebido pela Venda do Produto), ordenado por quantidade de vezes que o produto participou em vendas; */

select 
    prod.nome "Nome do Produto",
    SUM(ItVndProd.quantidade) "Quantidade Total de Vendas",
    concat("R$  ", SUM(ItVndProd.valor * ItVndProd.quantidade)) "Valor Total Recebido pela Venda do Produto"
from produtos prod
	join itensvendaprod ItVndProd on prod.idProduto = ItVndProd.Produto_idProduto
	group by prod.nome
order by  SUM(ItVndProd.quantidade) asc;
