drop database if exists loja;
create database loja;
use loja;

show databases;

create table produtos(
	id int primary key auto_increment,
    nome varchar(100) not null,
    preco decimal(10, 2) not null,
    estoque int not null
);

desc produtos;

create table vendas(
	id int auto_increment primary key,
    produto_id int,
    produto varchar(100) not null,
    quantidade int not null,
    valor_total decimal(10, 2) not null,
    data_venda date not null,
    foreign key(produto_id) references produtos(id)
);

desc vendas;


insert into produtos (nome, preco, estoque) values
('Camiseta Básica', 39.90, 120),
('Calça Jeans', 129.99, 60),
('Tênis Esportivo', 249.50, 35),
('Jaqueta de Couro', 399.00, 15),
('Boné Aba Curva', 29.99, 80),
('Relógio Digital', 89.90, 50),
('Óculos de Sol', 59.90, 70),
('Mochila Escolar', 79.90, 40),
('Carteira Masculina', 45.00, 55),
('Perfume Importado', 299.99, 25),
('Notebook Gamer', 4999.00, 10),
('Mouse Sem Fio', 59.99, 100),
('Teclado Mecânico', 249.90, 30),
('Smartphone X200', 1999.00, 20),
('Fone Bluetooth', 149.90, 75),
('Smartwatch Fit', 299.00, 32),
('Caixa de Som Portátil', 129.00, 45),
('Cadeira Gamer', 899.00, 12),
('Monitor 27 Polegadas', 1299.00, 18),
('Tablet Pro 10"', 1599.00, 22
);

select * from produtos;

INSERT INTO vendas (produto_id, produto, quantidade, valor_total, data_venda) VALUES
(1, 'Camiseta Básica', 2, 79.80, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(2, 'Calça Jeans', 1, 129.99, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(3, 'Tênis Esportivo', 1, 249.50, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(4, 'Jaqueta de Couro', 1, 399.00, DATE_SUB(CURDATE(), INTERVAL 7 DAY)),
(5, 'Boné Aba Curva', 3, 89.97, DATE_SUB(CURDATE(), INTERVAL 9 DAY)),
(6, 'Relógio Digital', 1, 89.90, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(7, 'Óculos de Sol', 2, 119.80, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(8, 'Mochila Escolar', 1, 79.90, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(9, 'Carteira Masculina', 2, 90.00, DATE_SUB(CURDATE(), INTERVAL 8 DAY)),
(10, 'Perfume Importado', 1, 299.99, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(11, 'Notebook Gamer', 1, 4999.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(12, 'Mouse Sem Fio', 4, 239.96, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(13, 'Teclado Mecânico', 1, 249.90, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(14, 'Smartphone X200', 1, 1999.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(15, 'Fone Bluetooth', 3, 449.70, DATE_SUB(CURDATE(), INTERVAL 9 DAY)),
(16, 'Smartwatch Fit', 1, 299.00, DATE_SUB(CURDATE(), INTERVAL 8 DAY)),
(17, 'Caixa de Som Portátil', 2, 258.00, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(18, 'Cadeira Gamer', 1, 899.00, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(19, 'Monitor 27 Polegadas', 1, 1299.00, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(20, 'Tablet Pro 10"', 1, 1599.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY));

select * from vendas;

select produto, data_venda from vendas; 

select * from vendas
where quantidade >= 3;

select * from vendas
where data_venda <= curdate() - interval 4 day;

/*Delimitar temporario para criar o bloco de codigo*/

delimiter //

create procedure AplicadorDeDescontoGeral(in porcentagem decimal(5, 2))
begin
-- atualizar a tabela de produtos aplicando o desconto
	update produtos
    set preco = preco *(1 - (porcentagem / 100));
    
    -- informar quantas linha foram afetadas
    
    select concat('desconto de', porcentagem, '% aplicando em ', row_count(),
     ' produtos.') as resultado;
     end //
     delimiter ;
     
     select * from produtos;
     
     set sql_safe_updates = 0;
     
     call AplicadorDeDescontoGeral(15.0);
     
     select * from produtos; 






