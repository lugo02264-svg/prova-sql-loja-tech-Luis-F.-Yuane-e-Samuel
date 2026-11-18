USE LojaTech2026;

-- 1.1
CREATE TABLE Categorias (
Codigo INT AUTO_INCREMENT PRIMARY KEY,
Nome VARCHAR(100) NOT NULL UNIQUE
);

-- 1.2
ALTER TABLE Produtos
ADD COLUMN CategoriaId INT,
ADD COLUMN Estoque INT NOT NULL DEFAULT 0,
ADD CONSTRAINT fkProdutosCategorias
FOREIGN KEY (CategoriaId) REFERENCES Categorias(Codigo);

-- 1.3
INSERT INTO Categorias (Nome) VALUES
('Design e Modelagem'),
('Elétrica e Eletrônica'),
('Gestão'),
('Programação'),
('Sistemas Operacionais');

UPDATE Produtos
SET CategoriaId = (SELECT Codigo FROM Categorias WHERE Nome = 'Design e Modelagem')
WHERE Codigo IN (1, 6, 7, 8);

UPDATE Produtos
SET CategoriaId = (SELECT Codigo FROM Categorias WHERE Nome = 'Elétrica e Eletrônica')
WHERE Codigo IN (2, 3);

UPDATE Produtos
SET CategoriaId = (SELECT Codigo FROM Categorias WHERE Nome = 'Gestão')
WHERE Codigo IN (4, 5);

UPDATE Produtos
SET CategoriaId = (SELECT Codigo FROM Categorias WHERE Nome = 'Programação')
WHERE Codigo IN (9, 10);

UPDATE Produtos
SET CategoriaId = (SELECT Codigo FROM Categorias WHERE Nome = 'Sistemas Operacionais')
WHERE Codigo = 11;

UPDATE Produtos SET Estoque = 20 WHERE Codigo IN (1, 3, 4, 5, 7, 8, 9, 10, 11);
UPDATE Produtos SET Estoque = 3 WHERE Codigo = 2;
UPDATE Produtos SET Estoque = 0 WHERE Codigo = 6;

-- 1.4
ALTER TABLE Clientes ADD COLUMN CEP VARCHAR(9);
UPDATE Clientes SET CEP = '12200-000' WHERE Codigo = 1;
UPDATE Clientes SET CEP = '40000-000' WHERE Codigo = 2;

