create database Teste;
show databases;

use Teste;

create table alunos (
 id int auto_increment primary key, 
 nome varchar(100) not null,
 idade int,
 disciplina varchar(50)
 );
 
 show tables;
 
 insert into alunos (nome, idade, disciplina)
 values
 ('joão carlos', 17, 'Banco de Dados'),
 ('Maria Rita', 23, 'Lógica de Programação'),
 ('Renato da Silva', 28, 'Banco de Dados'),
 ('Evelin Duarte', 32, 'Lógica de programação'),
 ('Mariana Alves', 18, 'Modelagem de Sistemas'),
 ('carlos Lima', 17, 'Desenvolvimento Web'),
 ('Ana Souza', 16, 'Banco de Dados'),
 ('Marcelo Vieira', 25, 'programação de Aplicativos'),
 ('Andre Gregorio', 22, 'Desenvolvimento Web');
 
 select * from alunos; 

 select nome, idade from alunos;
 
 select * from alunos where disciplina= 'Banco de Dados';
 
  select * from alunos where idade >= 19;
  
  select nome from alunos order by nome asc; 
  
  select nome, idade from alunos order by idade asc; 
  
   select * from alunos
   where disciplina  = 'banco de dados' or disciplina = 'programação de Aplicativos'; 
   
   select count(*) from alunos;
   
   select avg(idade) from alunos;
   
   select disciplina, count(*) as total_alunos from alunos group by disciplina; 
  
   update alunos set idade = 19 where id = 7;
   select * from alunos; 
   
   update alunos set disciplina  =  'programação de Mobile' where disciplina = 'programação de Aplicativos';
   select * from alunos; 
   
   delete from alunos where nome= 'Andre Gregorio';
   select * from alunos; 
   
   alter table alunos add email varchar(200);
   select * from alunos; 
   
   alter table alunos modify disciplina varchar(150);
   select * from alunos; 
   
   alter table alunos drop email;
   select * from alunos; 
   
   select * from alunos where nome like 'A%';
   
   select * from alunos where nome like '%A';
   
   select * from alunos where nome like '%e%';
   
   select disciplina from alunos group by disciplina having avg (idade) > 19;
   
   select nome, idade from alunos where idade = (select max(idade) from alunos);
   
   create table alunos_bd as select * from alunos where disciplina = 'Banco de Dados';
   select * from alunos_bd; 
   
   
   create database biblioteca_db;
   show databases;
   
   use biblioteca_db;
   
   create table livros(
	id int auto_increment primary key, 
	titulo varchar(150) not null,
	autor varchar(100),
	ano_publicado int,
	disponivel boolean 
	);


   
   
	
   use Teste;
    
    

