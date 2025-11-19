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

create table professores (
	id int auto_increment primary key,
    nome varchar(100) not null,
    especialidade varchar(100)
);

create table turmas (
	id int auto_increment primary key,
    nome varchar(50) not null,
    professor_id int,
    horario time,
    foreign key (professor_id) references professores(id)
);

create table disciplinas (
	id int auto_increment primary key,
    nome varchar(100) not null,
    carga_horaria int
);

create table notas (
	id int auto_increment primary key,
    aluno_id int,
    disciplina_id int,
	nota decimal (2, 1),
    bimestre int,
    foreign key (aluno_id) references alunos(id),
    foreign key (disciplina_id) references disciplinas(id)
);

alter table alunos 
add foreign key (turma_id) references turmas(id);

insert into professores (nome, especialidade)
values
('Carlos Silva', 'Matemática'),
('Ana Santos', 'Português'),
('Marcos Lima', 'História'),
('Julia Costa', 'Ciências'),
('Roberto Alves', 'Geografia');

insert into turmas (nome, professor_id, horario)
values
('1º Ano A', 1, '08:00:00'),
('1º Ano B', 2, '10:00:00'),
('2º Ano A', 3, '08:00:00'),
('2º Ano B', 4, '13:00:00'),
('3º Ano A', 5, '14:00:00'); 


INSERT INTO alunos (nome, email, data_nascimento, turma_id) VALUES
('João da Silva', 'joao.silva@example.com', '2005-08-12', 3),
('Maria Oliveira', 'maria.oliveira@example.com', '2006-03-25', 2),
('Carlos Pereira', 'carlos.pereira@example.com', '2004-11-10', 1),
('Ana Souza', 'ana.souza@example.com', '2005-01-18', 3),
('Fernanda Lima', 'fernanda.lima@example.com', '2006-07-09', 2),
('Rafael Gomes', 'rafael.gomes@example.com', '2004-09-30', 1),
('Juliana Castro', 'juliana.castro@example.com', '2005-12-02', 3),
('Paulo Mendes', 'paulo.mendes@example.com', '2006-02-14', 2);

INSERT INTO disciplinas (nome, carga_horaria) VALUES
('Matemática', 80),
('Português', 60),
('História', 40),
('Geografia', 40),
('Física', 70),
('Química', 70),
('Biologia', 60),
('Inglês', 50);

INSERT INTO notas (aluno_id, disciplina_id, nota, bimestre) VALUES
(1, 2, 8.5, 1),
(2, 1, 7.0, 1),
(3, 4, 9.2, 1),
(4, 3, 6.8, 1),
(5, 5, 8.0, 2),
(6, 2, 7.5, 2),
(7, 6, 9.0, 2),
(8, 1, 6.2, 2);

/*======================================================================================================================*/

-- Listar todos os alunos da turma 1° Ano A
select * from alunos where turma_id=1;
 
/*======================================================================================================================*/
 
-- Listar todos os alunos em ordem alfabética 
select * from alunos order by nome asc;

/*======================================================================================================================*/

-- Listar alunos nascidos após o ano de 2010 (coluna nome e data_nascimento)
select nome, data_nascimento from alunos where data_nascimento > '2002-12-31' order by data_nascimento;

/*======================================================================================================================*/

-- Listar quantos alunos tem em cada turma (Count)
 SELECT turmas.nome AS turma, COUNT(alunos.id) AS total_alunos
FROM turmas 
LEFT JOIN alunos ON alunos.turma_id = turmas.id
GROUP BY turmas.id, turmas.nome;

/*======================================================================================================================*/

-- Mostrar a média de notas por disciplina (AVG)
SELECT disciplinas.nome AS disciplina,
       AVG(notas.nota) AS media_notas
FROM disciplinas
JOIN notas ON notas.disciplina_id = disciplinas.id
GROUP BY disciplinas.id, disciplinas.nome
ORDER BY disciplinas.nome;

/*======================================================================================================================*/

-- INNER JOIN Básico
-- Alunos com suas turmas e professores
SELECT
    A.nome AS Aluno,
    T.nome AS Turma,
    P.nome AS Professor_Regente
FROM
    alunos A
INNER JOIN
    turmas T ON A.turma_id = T.id -- Conecta Aluno à Turma
INNER JOIN
    professores P ON T.professor_id = P.id -- Conecta Turma ao Professor
ORDER BY
    Aluno;
    
/*======================================================================================================================*/
    
-- JOIN com múltiplas tabelas
-- notas dos alunos com detalhes

SELECT
    A.nome AS Nome_Aluno,
    T.nome AS Turma,
    D.nome AS Disciplina,
    N.nota AS Nota,
    N.bimestre AS Bimestre
FROM
    alunos A
INNER JOIN
    notas N ON A.id = N.aluno_id       
INNER JOIN
    disciplinas D ON N.disciplina_id = D.id 
INNER JOIN
    turmas T ON A.turma_id = T.id     
ORDER BY
    Nome_Aluno, Disciplina, Bimestre;
    
/*======================================================================================================================*/

-- PROCEDURES
-- Para calcular média do aluno
DELIMITER //

CREATE PROCEDURE CalcularMediaGeral (
    IN p_aluno_id INT,
    OUT p_media_geral DECIMAL(4, 2)
)
BEGIN
  
    SELECT
        AVG(nota)
    INTO
        p_media_geral
    FROM
        notas
    WHERE
        aluno_id = p_aluno_id;
END //

DELIMITER ;
SET @media_geral_do_aluno = 0.0;
CALL CalcularMediaGeral(2, @media_geral_do_aluno);
SELECT 'Média Geral do Aluno 2:' AS Teste, @media_geral_do_aluno AS Media_Geral_Calculada;

/*======================================================================================================================*/

-- PROCEDURES
-- Para listar alunos por turma
 DELIMITER //

CREATE PROCEDURE ListarAlunosPorTurma (
    IN p_turma_id INT 
)
BEGIN
    
    SELECT
        A.nome AS Nome_do_Aluno,
        A.email AS Email_do_Aluno,
        T.nome AS Nome_da_Turma,
        P.nome AS Professor_Regente
    FROM
        alunos A
    INNER JOIN
        turmas T ON A.turma_id = T.id 
    INNER JOIN
        professores P ON T.professor_id = P.id 
    WHERE
        A.turma_id = p_turma_id 
    ORDER BY
        A.nome;
END //

DELIMITER ;

CALL ListarAlunosPorTurma(1);

/*======================================================================================================================*/

-- Query para mostrar Aprovado se nota maior que 7.0 ou reprovado se nota menor
SELECT
    A.nome AS Nome_do_Aluno,
    D.nome AS Nome_da_Disciplina,
    AVG(N.nota) AS Media_Final,
    CASE
        WHEN AVG(N.nota) >= 7.0 THEN 'APROVADO'
        ELSE 'REPROVADO'
    END AS Status_Final
FROM
    alunos A
INNER JOIN
    notas N ON A.id = N.aluno_id
INNER JOIN
    disciplinas D ON N.disciplina_id = D.id
GROUP BY
    A.id, D.id, A.nome, D.nome
ORDER BY
    Nome_do_Aluno, Nome_da_Disciplina;

/*======================================================================================================================*/

-- Rankear os melhores alunos
SELECT
    A.nome AS Nome_do_Aluno,
    -- Calcula a média geral de todas as notas do aluno (em todas as disciplinas e bimestres)
    AVG(N.nota) AS Media_Geral,
    -- Usa uma função de janela (Window Function) para ranquear os alunos
    -- RANK() salta posições em caso de empate (ex: 1º, 2º, 2º, 4º)
    -- DENSE_RANK() não salta posições em caso de empate (ex: 1º, 2º, 2º, 3º)
    RANK() OVER (ORDER BY AVG(N.nota) DESC) AS Posicao_Ranking
FROM
    alunos A
INNER JOIN
    notas N ON A.id = N.aluno_id -- Conecta Alunos às Notas
GROUP BY
    A.id, A.nome -- Agrupa para calcular a média de cada aluno
ORDER BY
    Media_Geral DESC;








