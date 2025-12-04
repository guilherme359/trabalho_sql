-- criando usuarios 


select version();

create user 'analista_guilherme'@'localhost';

set password for 'analista_guilherme'@'localhost' = password ('guima123');

alter user 'analista_guilherme'@'localhost' password expire interval 90 day;

select user, host from mysql.user where user like '%guilherme%';

create user 'usuario_externo'@'192.168.1.%';

set password for 'usuario_externo'@'192.168.1.%' = password ('Usuario@2025'); 

alter user  'usuario_externo'@'192.168.1.%' password expire never;

select user, host from mysql.user where user like '%usuario%';

select 
	user,
    host,
    password_expired as 'Senha Expirarda?'
from mysql.user
where user not like 'mysql%'
and user != 'root';

-- criar um usuario com privilegios especificos

create user 'usuario_leitor'@'localhost';

set password for 'usuario_leitor'@'localhost' = password ('leitor@2025');

create database if not exists empresa_dados;

show databases;

grant select on empresa_dados.* to 'usuario_leitor'@'localhost';

flush privileges;

show grants for 'usuario_leitor'@'localhost';

-- criptografando informações

create database loja_virtual;
use loja_virtual;

create table clientes (
	id int auto_increment primary key,
    nome_completo varchar(100) not null,
    cpf_visivel varchar(14),
    cpf_criptografado varbinary (255),
    email varchar(100),
    telefone varchar(20),
    data_cadastro timestamp default current_timestamp
);

create index idx_cliente_nome on clientes(nome_completo);

describe clientes;

set @minha_chave_secreta = 'MinhaSenhaForte@2025!';

insert into clientes
(nome_completo,  cpf_criptografado, email, telefone)
values ('guilherme GM', aes_encrypt('123.456.789.00', @minha_chave_secreta),
'guilherme@guima.com', '(44)99999-1234');

SELECT * FROM clientes;

select hex(cpf_criptografado) from clientes;

-- descriptografando 

set @minha_chave_secreta = 'MinhaSenhaForte@2025!';

select id, nome_completo,
cast(aes_decrypt(cpf_criptografado, @minha_chave_secreta)
as char) as cpf_descriptografado,
email, telefone from clientes;




