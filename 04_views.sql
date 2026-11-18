USE LojaTech2026;

-- 4.1
CREATE OR REPLACE VIEW vwProdutosAtivos AS
SELECT p.Codigo, p.Descricao, c.Nome AS Categoria, p.ValorVenda, p.Estoque
FROM Produtos AS p
LEFT JOIN Categorias AS c ON c.Codigo = p.CategoriaId
WHERE p.Ativo = 1;

-- 4.2
CREATE OR REPLACE VIEW vwResumoClientes AS
SELECT c.Codigo, c.Nome, COUNT(v.Codigo) AS QuantidadeCompras,
COALESCE(SUM(v.Quantidade * v.ValorVenda), 0) AS TotalGasto,
MAX(v.DataVenda) AS UltimaCompra,
CASE
WHEN COALESCE(SUM(v.Quantidade * v.ValorVenda), 0) = 0 THEN 'Sem Compras'
WHEN COALESCE(SUM(v.Quantidade * v.ValorVenda), 0) < 300 THEN 'Bronze'
WHEN COALESCE(SUM(v.Quantidade * v.ValorVenda), 0) < 700 THEN 'Prata'
ELSE 'Ouro'
END AS Perfil
FROM Clientes AS c
LEFT JOIN Vendas AS v ON v.Cliente = c.Codigo
GROUP BY c.Codigo, c.Nome;

-- 4.3
SELECT Codigo, Nome, QuantidadeCompras, TotalGasto, UltimaCompra, Perfil
FROM vwResumoClientes
WHERE Perfil = 'Ouro'
ORDER BY TotalGasto DESC, Codigo;

