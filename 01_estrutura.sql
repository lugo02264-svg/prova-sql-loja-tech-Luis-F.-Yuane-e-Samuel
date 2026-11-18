USE LojaTech2026;
create table Categorias (
Codigo int primary key auto_increment,
Nome varchar(100) not null unique
);

-- alter table Produtos add CategoriaID int, foreign key CategoriaID references Categorias (Codigo), add Estoque int not null default 0, ;

insert into Categorias (Nome) values 
('Design e Modelagem'),
('Elétrica e Eletrônica'),
('luis'),
('Gestão'),
('yuane'),
('livia'),
('samuel'),
('santos'),
('tamira'),
('Programação'),
('Sistemas Operacionais');

update
	Categorias
set
	Nome = 'Design e Modelagem'
where
	Codigo = 6 and 7 and 8;
    
update
	Categorias
set
	Nome = 'Elétrica e Eletrônica'
where
	Codigo = 3;
    
update
	Categorias
set
	Nome = 'Gestão'
where
	Codigo = 5;
    
update
	Categorias
set
	Nome = 'Programação'
where
	Codigo = 9;

select * from Categorias;

