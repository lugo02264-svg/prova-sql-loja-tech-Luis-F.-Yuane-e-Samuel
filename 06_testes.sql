USE LojaTech2026;

-- 6.1
DROP PROCEDURE IF EXISTS executar_testes_loja;
DELIMITER $$
CREATE PROCEDURE executar_testes_loja()
BEGIN
DECLARE venda_teste INT;
DECLARE estoque_inicial INT;
DECLARE preco_tabela DECIMAL(18,2);
DECLARE historicos_iniciais INT;
DECLARE historicos_preco INT;
DECLARE historicos_descricao INT;
DECLARE excluidas_iniciais INT;
DECLARE houve_erro BOOLEAN DEFAULT FALSE;
DECLARE estado_erro CHAR(5) DEFAULT '';
DECLARE mensagem_erro TEXT DEFAULT '';
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
RESIGNAL;
END;

START TRANSACTION;

SELECT Estoque, ValorVenda INTO estoque_inicial, preco_tabela
FROM Produtos WHERE Codigo = 1;
INSERT INTO Vendas (Cliente, Produto, DataVenda, Quantidade, ValorVenda)
VALUES (1, 1, NULL, 1, NULL);
SET venda_teste = LAST_INSERT_ID();
SELECT '6.1.1: preço de tabela, data atual e estoque inicial menos 1' AS Esperado,
v.Codigo, v.ValorVenda, preco_tabela AS PrecoEsperado,
v.DataVenda, CURRENT_DATE() AS DataEsperada,
p.Estoque, estoque_inicial - 1 AS EstoqueEsperado
FROM Vendas AS v JOIN Produtos AS p ON p.Codigo = v.Produto
WHERE v.Codigo = venda_teste;

SAVEPOINT antes_teste_2;
SET houve_erro = FALSE;
SET estado_erro = '';
SET mensagem_erro = '';
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1 estado_erro = RETURNED_SQLSTATE,
mensagem_erro = MESSAGE_TEXT;
SET houve_erro = TRUE;
END;
INSERT INTO Vendas (Cliente, Produto, DataVenda, Quantidade, ValorVenda)
VALUES (1, 1, CURRENT_DATE(), 0, 10);
END;
ROLLBACK TO SAVEPOINT antes_teste_2;
SELECT '6.1.2: bloqueio com SQLSTATE 45000' AS Esperado,
houve_erro AS HouveErro, estado_erro AS SQLStateObtido, mensagem_erro AS Mensagem;

SAVEPOINT antes_teste_3;
SET houve_erro = FALSE;
SET estado_erro = '';
SET mensagem_erro = '';
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1 estado_erro = RETURNED_SQLSTATE,
mensagem_erro = MESSAGE_TEXT;
SET houve_erro = TRUE;
END;
INSERT INTO Vendas (Cliente, Produto, DataVenda, Quantidade, ValorVenda)
VALUES (1, 6, CURRENT_DATE(), 1, 10);
END;
ROLLBACK TO SAVEPOINT antes_teste_3;
SELECT '6.1.3: bloqueio de produto inativo com SQLSTATE 45000' AS Esperado,
houve_erro AS HouveErro, estado_erro AS SQLStateObtido, mensagem_erro AS Mensagem;

SAVEPOINT antes_teste_4;
SET houve_erro = FALSE;
SET estado_erro = '';
SET mensagem_erro = '';
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
BEGIN
GET DIAGNOSTICS CONDITION 1 estado_erro = RETURNED_SQLSTATE,
mensagem_erro = MESSAGE_TEXT;
SET houve_erro = TRUE;
END;
INSERT INTO Vendas (Cliente, Produto, DataVenda, Quantidade, ValorVenda)
VALUES (1, 2, CURRENT_DATE(), 4, 10);
END;
ROLLBACK TO SAVEPOINT antes_teste_4;
SELECT '6.1.4: bloqueio por estoque insuficiente com SQLSTATE 45000' AS Esperado,
houve_erro AS HouveErro, estado_erro AS SQLStateObtido, mensagem_erro AS Mensagem;

SELECT COUNT(*) INTO historicos_iniciais FROM HistoricoPrecos;
UPDATE Produtos SET ValorVenda = ValorVenda + 1 WHERE Codigo = 1;
SELECT COUNT(*) INTO historicos_preco FROM HistoricoPrecos;
UPDATE Produtos SET Descricao = CONCAT(Descricao, ' - TESTE') WHERE Codigo = 1;
SELECT COUNT(*) INTO historicos_descricao FROM HistoricoPrecos;
SELECT '6.1.5: preço adiciona 1 histórico; descrição não adiciona' AS Esperado,
historicos_iniciais AS Antes, historicos_preco AS AposPreco,
historicos_descricao AS AposDescricao;

SELECT COUNT(*) INTO excluidas_iniciais FROM VendasExcluidas;
DELETE FROM Vendas WHERE Codigo = venda_teste;
SELECT '6.1.6: estoque original restaurado e uma exclusão registrada' AS Esperado,
p.Estoque, estoque_inicial AS EstoqueEsperado,
excluidas_iniciais AS LogsAntes,
(SELECT COUNT(*) FROM VendasExcluidas) AS LogsDepois
FROM Produtos AS p WHERE p.Codigo = 1;

ROLLBACK;
END$$
DELIMITER ;
CALL executar_testes_loja();
DROP PROCEDURE executar_testes_loja;

