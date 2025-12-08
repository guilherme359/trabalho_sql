
-- curso segurança mariadb-base inicial					   

drop database if exists guilherme;
create database guilherme;
use guilherme;

-- Tabela 1: Departamentos	                               

create table departamentos(
	id int primary key auto_increment,
    nome varchar(50) not null,
    sigla varchar(10)
);


-- Tabela 2:funcionarios (COM DADOS SENSÍVEIS VISEVEIS)    

CREATE TABLE funcionarios (
id INT PRIMARY KEY AUTO_INCREMENT,
depto_id INT,
nome VARCHAR(100) NOT NULL,
email VARCHAR(100),
cpf VARCHAR(14),
telefone VARCHAR(20),
salario DECIMAL(10,2),
cargo VARCHAR(50),
data_admissao DATE,
FOREIGN KEY (depto_id) REFERENCES departamentos(id)
);


-- TABELA 3: Projetos

CREATE TABLE projetos (
id INT PRIMARY KEY AUTO_INCREMENT, 
nome VARCHAR(100) NOT NULL,
orcamento DECIMAL(10,2),
data_inicio DATE
);


-- TABELA 4: Alocação

CREATE TABLE alocacao (
id INT PRIMARY KEY AUTO_INCREMENT,
funcionario_id INT,
projeto_id INT,
horas_semanais INT,
FOREIGN KEY (funcionario_id) REFERENCES funcionarios (id),
FOREIGN KEY (projeto_id) REFERENCES projetos(id)
);

-- INSERIR DADOS DE EXEMPLO
-- Departamentos
INSERT INTO departamentos (nome, sigla) VALUES
('Tecnologia da Informação', 'TI'),
('Recursos Humanos', 'RH'),
('Financeiro', 'FIN'),
('Marketing', 'MKT'),
('Vendas', 'VND');

-- Funcionários (CPFS VISÍVEIS-problema de segurança!)

INSERT INTO funcionarios (depto_id, nome, email, cpf, telefone, salario, cargo, data_admissao) VALUES

(1, 'Ana Silva', 'ana@empresa.com', '123.456.789-01', '(11) 99999-8888', 8500.00, 'Gerente de TI', '2020-03-10'),
(1, 'Bruno Santos', 'bruno@empresa.com', '987.654.321-09', '(11) 98888-7777', 6500.00, 'Desenvolvedor', '2021-07-15'),
(2, 'Carla Pereira', 'carla@empresa.com', '456.789.123-45', '(11) 97777-6666', 5500.00, 'Analista RH', '2019-01-20'),
(3, 'Diego Costa', 'diego@empresa.com', '789.123.456-78', '(11) 96666-5555', 7200.00, 'Analista Financeiro', '2020-11-05'),
(4, 'Elena Rodrigues', 'elena@empresa.com', '321.654.987-32', '(11) 95555-4444', 4800.00, 'Marketing', '2022-06-18'),
(5, 'Fernando Gomes', 'fernando@empresa.com', '654.987.321-65', '(11) 94444-3333', 6800.00, 'Vendedor', "2021-09-22"),
(1, 'Gabriela Martins', 'gabriela@empresa.com', '987.321.654-98', '(11) 93333-2222',5300.00, 'Analista de Sistemas', '2020-08-14');

-- Projetos

INSERT INTO projetos (nome, orcamento, data_inicio) VALUES 
('Sistema de Gestão', 120000.00, '2024-01-15'), 
('Site Nova Empresa', 80000.00, '2024-02-01'), 
('App Mobile', 150000.00, '2024-03-10');

-- Alocação

INSERT INTO alocacao (funcionario_id, projeto_id, horas_semanais) VALUES
(1, 1, 20),
(2, 1, 30),
(2, 3, 10),
(5, 2, 25),
(7, 3, 15);


-- MENSAGEM FINAL

SELECT 'Base de dados criada com sucesso!' as mensagem;
SELECT' ATENÇÃO: CPFs estão VISÍVEIS no banco!' as alerta;
SELECT 'Total de funcionários: ' as info, COUNT(*) as quantidade FROM funcionarios;

-- Mostra todos os dados (incluindo CPF visível!)
SELECT * FROM funcionarios;

-- Junta duas tabelas
SELECT f.nome, f.cargo, d.nome as departamento
FROM funcionarios f
JOIN departamentos d ON f.depto_id = d.id;

-- Contar funcionários em cada departamento
SELECT d.nome, COUNT(f.id) as total_funcionarios
FROM departamentos d
LEFT JOIN funcionarios f ON d.id = f.depto_id
GROUP BY d.nome
ORDER BY total_funcionarios DESC;

-- Salário médio por departamento
SELECT d.nome,
ROUND(AVG(f.salario), 2) as salario_medio,
COUNT(f.id) as qtde_funcionarios
FROM departamentos d
JOIN funcionarios f ON d.id = f.depto_id
GROUP BY d.nome
ORDER BY salario_medio DESC;

-- Problema GRAVE: CPFs em texto claro
SELECT nome, cpf, email, telefone
FROM funcionarios
WHERE cpf IS NOT NULL;



-- Informações que não deveriam estar juntas
SELECT
nome,
CONCAT('CPF:', cpf) as dado_sensivel,
CONCAT('Salário: R$', FORMAT(salario, 2)) as info_financeira,
telefone
FROM funcionarios;


-- Se este relatório vazar, é DESASTRE
SELECT
f.nome as Funcionario,
f.cpf as CPF,
f.email as Email,
f.telefone as Telefone,
f.salario as Salario,
d.nome as Departamento,
GROUP_CONCAT(p.nome) as Projetos
FROM funcionarios f
JOIN departamentos d ON f.depto_id = d.id
LEFT JOIN alocacao a ON f.id = a.funcionario_id
LEFT JOIN projetos p ON a.projeto_id = p.id
GROUP BY f.id;

-- Query 4.1: Criar usuários com diferentes acessos
-- Usuário 1: Gerente (acesso total)
CREATE USER 'gerente_ti'@'localhost';
SET PASSWORD FOR 'gerente_ti'@'localhost' = PASSWORD('Ger3nt3@20241!');
GRANT ALL PRIVILEGES ON guilherme.* TO 'gerente_ti'@'localhost';


-- Usuário 2: Analista (só consulta)
CREATE USER 'analista_rh'@'localhost';
SET PASSWORD FOR 'analista_rh'@'localhost' = PASSWORD('Anal1st@20241');
GRANT SELECT ON guilherme.* TO 'analista_rh'@'localhost';



-- Usuário 3: Estagiário (só vé algumas colunas)
CREATE USER 'estagiario'@'localhost';
SET PASSWORD FOR 'estagiario'@'localhost' = PASSWORD('Est4gi@20241'); 

-- Ver todos os usuários

SELECT User, Host FROM mysql.user WHERE User LIKE '%empresa%' OR User IN ('gerente_ti', 'analista_rh', 'estagiario');


-- Ver permissões de um usuário

SHOW GRANTS FOR 'analista_rh'@'localhost';


