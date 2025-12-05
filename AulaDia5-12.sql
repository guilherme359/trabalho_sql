create database loja;
use loja; 

-- Usuario 1: Gerente
create user 'gerente'@'localhost';
set password for 'gerente'@'localhost' = password('Ger3nt3@2024!');
alter user 'gerente'@'localhost' password expire interval 60 day;
select user, host from mysql.user where user like '%gerente%';

-- Usuario 2: Vendedor
create user 'vendedor_1'@'192.168.10.%';
set password for 'vendedor_1'@'192.168.10.%' = password('V3nd3dor@2024');
alter user 'vendedor_1'@'192.168.10.%' password expire never;
select user, host from mysql.user where user like '%vendedor%';
grant select, insert on loja.* to 'vendedor_1'@'192.168.10.%';
flush privileges;

-- Usuario 3: Estagiario
create user 'estagiario_ti'@'localhost';
set password for 'estagiario_ti'@'localhost' = password('Est4gi@2024');
alter user 'estagiario_ti'@'localhost' password expire interval 30 day;
grant select on loja.* to 'estagiario_ti'@'localhost';

-- Usuario 3: Backup
create user 'backup_user';
set password for 'backup_user' = password('Backup@2024');
alter user 'backup_user' password expire interval 365 day;

-- verificar os usuarios, pelo menos acho que ta verificando!?
select user, host from mysql.user;

-- Criar tabela de clientes
create table clientes (
	id int auto_increment primary key,
    nome_completo varchar(100) not null,
    email varchar(100),
	cpf_criptografado varbinary (255),
    cpf_visivel varchar(14),
    DataNascimento date,
    data_cadastro timestamp default current_timestamp
);

set @Minha_Chave_Secreta = 'MinhaSenhaForte@2024';
-- clientes cripto
insert into clientes  
	(nome_completo, email, cpf_criptografado,  DataNascimento)
    values ('guilherme guimaraes', 'guilherme@guima.com', aes_encrypt('123.456.789.00', @Minha_Chave_Secreta), '2006-12-28'),
	('vinicios dapopo', 'vinizin@dado.com', aes_encrypt('321.654.987.11', @Minha_Chave_Secreta), '2007-11-18');
    
select * from clientes;
drop table clientes;
select hex(cpf_criptografado) from clientes;

-- clientes descript

insert into clientes (nome_completo, email, cpf_visivel,  DataNascimento)
values ('vitão silvio', 'vitinho@silvinho', '000.000.000.00', '1930-12-22'),
('ricardinho gomes', 'ricardo@lopes', '519.315.572.81', '2024-02-04'),
('miglinho eleticos', 'migleu@porpa', '651.713.153.54', '2004-05-11');

select nome_completo, cpf_visivel from clientes; 

select nome_completo, cpf_criptografado from clientes; 

select nome_completo,
cast(aes_decrypt(cpf_criptografado, @minha_chave_secreta)
as char) as cpf_descriptografado from clientes where cpf_criptografado is not null;




	







