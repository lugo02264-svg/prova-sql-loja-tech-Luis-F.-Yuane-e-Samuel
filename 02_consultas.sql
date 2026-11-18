USE LojaTech2026;

-- 2.1
select Codigo, Nome, Cidade, DataNascimento from Clientes where UF = 'SP' and DataNascimento between '01/01/1980' and '31/12/1988' and Nome like 'M%' or 'P%' order by Nome;

-- 2.2
select Nome, IFNULL (Email, 'SEM Email'), IFNULL (UF, 'SEM CEP')from Clientes;

-- 2.3 
select C.Nome, P.Descricao, V.DataVenda, V.Quantidade, V.ValorVenda, (V.Quantidade * V.ValorVenda) as 'Total do item'
from Clientes C 
inner join Vendas V on C.Codigo = V.fkVendasClientes
inner join Produtos P on P.Codigo = V.fkVendasProdutos
order by DataVenda asc;

-- 2.4
 select C.Nome, C.Codigo
 from Clientes C 
 left join Vendas V on C.Codigo = V.Cliente
 where V.DataVenda is null;
 
-- 2.5 
 select P.Descricao, P.Codigo
 from Produtos P 
 right join Vendas V on P.Codigo = V.Produto
 where V.DataVenda is null;
 
-- 2.6
select 
	Nome,
Case
		WHEN ValorVenda between 0 and 100 then "Bronze"
        when ValorVenda between 101 and 200 then "Prata"
        when ValorVenda between 201 and 300 then "Ouro"
        when ValorVenda > 300 then "platina"
        else "Não Classificado!"
	end as "Tipo do Produto"
    
from Clientes;