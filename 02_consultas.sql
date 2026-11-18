USE LojaTech2026;

-- 2.1: clientes de SP nascidos no período e com nome iniciado em M ou P
SELECT Codigo, Nome, Cidade, DataNascimento
FROM Clientes
WHERE UF = 'SP'
AND DataNascimento BETWEEN '1980-01-01' AND '1988-12-31'
AND (Nome LIKE 'M%' OR Nome LIKE 'P%')
ORDER BY Nome;

-- 2.2: clientes com mensagens para e-mail e CEP nulos
SELECT Codigo, Nome, Cidade, UF, DataNascimento,
COALESCE(Email, 'SEM E-MAIL') AS Email,
COALESCE(CEP, 'SEM CEP') AS CEP
FROM Clientes;

-- 2.3: vendas detalhadas da mais recente para a mais antiga
SELECT c.Nome AS Cliente, p.Descricao AS Produto, v.DataVenda,
v.Quantidade, v.ValorVenda,
v.Quantidade * v.ValorVenda AS TotalItem
FROM Vendas AS v
INNER JOIN Clientes AS c ON c.Codigo = v.Cliente
INNER JOIN Produtos AS p ON p.Codigo = v.Produto
ORDER BY v.DataVenda DESC, v.Codigo DESC;

-- 2.4: clientes que nunca compraram
SELECT c.Codigo, c.Nome
FROM Clientes AS c
LEFT JOIN Vendas AS v ON v.Cliente = c.Codigo
WHERE v.Codigo IS NULL
ORDER BY c.Codigo;

-- 2.5: produtos que nunca foram vendidos
SELECT p.Codigo, p.Descricao
FROM Vendas AS v
RIGHT JOIN Produtos AS p ON v.Produto = p.Codigo
WHERE v.Codigo IS NULL
ORDER BY p.Codigo;

-- 2.6: perfil dos clientes pelo total gasto
SELECT c.Codigo, c.Nome,
COALESCE(SUM(v.Quantidade * v.ValorVenda), 0) AS TotalGasto,
CASE
WHEN COALESCE(SUM(v.Quantidade * v.ValorVenda), 0) = 0 THEN 'Sem Compras'
WHEN COALESCE(SUM(v.Quantidade * v.ValorVenda), 0) < 300 THEN 'Bronze'
WHEN COALESCE(SUM(v.Quantidade * v.ValorVenda), 0) < 700 THEN 'Prata'
ELSE 'Ouro'
END AS Perfil
FROM Clientes AS c
LEFT JOIN Vendas AS v ON v.Cliente = c.Codigo
GROUP BY c.Codigo, c.Nome
ORDER BY c.Codigo;
