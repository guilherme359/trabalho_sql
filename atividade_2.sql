drop database if exists escola;
create database escola;
use escola;
show databases;

create table alunos (
	id int auto_increment primary key,
	nome varchar(100) not null,
	email varchar(100) not null,
	data_nascimento date,
	turma_id int
);

create table professores(
	id int auto_increment primary key,
    nome varchar(100) not null,
    especialidade varchar(100)
);

create table turmas(
	id int auto_increment primary key,
    nome varchar(100) not null,
    professor_id int not null,
    horario time,
    foreign key (professor_id) references professores(id)
);

create table disciplinas (
	id int auto_increment primary key,
    nome varchar(100) not null,
    carga_horaria int
);

create table notas(
	id int auto_increment primary key,
    aluno_id int,
    disciplina_id int,
    nota decimal(2, 1),
    bimestre int,
    foreign key (aluno_id) references alunos(id),
    foreign key (disciplina_id) references disciplinas(id)
);

alter table alunos add foreign key turma(id) references turmas(id);
desc alunos;

insert into professores (nome, especialidade) values
('Carlos Alberto Mendes', 'Matematica'),
('Juliana Ribeiro Santos', 'Historia'),
('Marcos Vinicius Oliveira', 'Fisica'),
('Renata Almeida Costa', 'Biologia'),
('Fernanda Lopes Mrtins', 'Portugues');
select * from professores;

insert into turmas (nome, professor_id, horario) 
values
('1º ano A', 1, '08:00:00'),
('1º ano B', 2, '10:00:00'),
('2º ano A', 3, '08:00:00'),
('2º ano B', 4, '13:00:00'),
('3º ano A', 5, '14:00:00');
select * from turmas;










