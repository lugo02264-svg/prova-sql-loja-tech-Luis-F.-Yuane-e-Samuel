USE LojaTech2026;

-- 3.1
SELECT c.Codigo, c.Nome, COUNT(v.Codigo) AS NumeroCompras,
COALESCE(SUM(v.Quantidade), 0) AS TotalItens,
COALESCE(SUM(v.Quantidade * v.ValorVenda), 0) AS Faturamento,
COALESCE(ROUND(SUM(v.Quantidade * v.ValorVenda) / NULLIF(COUNT(v.Codigo), 0), 2), 0) AS TicketMedio
FROM Clientes AS c
LEFT JOIN Vendas AS v ON v.Cliente = c.Codigo
GROUP BY c.Codigo, c.Nome
ORDER BY Faturamento DESC, c.Codigo;

-- 3.2
SELECT c.Codigo, c.Nome, MIN(v.ValorVenda) AS MenorValor,
MAX(v.ValorVenda) AS MaiorValor
FROM Clientes AS c
INNER JOIN Vendas AS v ON v.Cliente = c.Codigo
GROUP BY c.Codigo, c.Nome
ORDER BY c.Nome;

-- 3.3
SELECT cat.Codigo, cat.Nome,
SUM(v.Quantidade * v.ValorVenda) AS Faturamento
FROM Categorias AS cat
INNER JOIN Produtos AS p ON p.CategoriaId = cat.Codigo
INNER JOIN Vendas AS v ON v.Produto = p.Codigo
GROUP BY cat.Codigo, cat.Nome
HAVING SUM(v.Quantidade * v.ValorVenda) > 900
ORDER BY Faturamento DESC;

-- 3.4
SELECT p.Codigo, p.Descricao, p.ValorVenda AS ValorTabela,
ROUND(AVG(v.ValorVenda), 2) AS ValorMedioPraticado,
SUM(v.Quantidade * (p.ValorVenda - v.ValorVenda)) AS DescontoTotal
FROM Produtos AS p
INNER JOIN Vendas AS v ON v.Produto = p.Codigo
GROUP BY p.Codigo, p.Descricao, p.ValorVenda
ORDER BY p.Codigo;

-- 3.5
SELECT DATE_FORMAT(DataVenda, '%Y-%m') AS Mes,
SUM(Quantidade * ValorVenda) AS Faturamento
FROM Vendas
WHERE DataVenda >= '2026-01-01' AND DataVenda < '2027-01-01'
GROUP BY DATE_FORMAT(DataVenda, '%Y-%m')
ORDER BY Mes;

-- 3.6
SELECT p.Codigo, p.Descricao, SUM(v.Quantidade) AS QuantidadeVendida
FROM Produtos AS p
INNER JOIN Vendas AS v ON v.Produto = p.Codigo
GROUP BY p.Codigo, p.Descricao
ORDER BY QuantidadeVendida DESC, p.Codigo
LIMIT 3;

