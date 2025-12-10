-- CURSO SEGURANÇA MARIADB - BASE INICIAL (CÓDIGO FINAL CORRIGIDO)
-- ==========================================================

-- PASSO 1: Criar o banco de dados
DROP DATABASE IF EXISTS empresaTop;
CREATE DATABASE empresaTop;
USE empresaTop;

-- TABELA 1: Departamentos
CREATE TABLE departamentos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    sigla VARCHAR(10)
);

-- TABELA 2: Funcionários (COM DADOS SENSÍVEIS VISÍVEIS!)

CREATE TABLE funcionarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    dept_id INT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    cpf VARCHAR(14), -- DADO SENSÍVEL VISÍVEL (PROBLEMA)
    telefone VARCHAR(20),
    salario DECIMAL(10,2),
    cargo VARCHAR(50),
    data_admissao DATE,
    FOREIGN KEY (dept_id) REFERENCES departamentos(id)
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
    funcionario_id INT NOT NULL,
    projeto_id INT NOT NULL,
    horas_semanais INT,
    PRIMARY KEY (funcionario_id, projeto_id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(id),
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

-- Funcionários (CPFs VISÍVEIS - problema de segurança)
INSERT INTO funcionarios (dept_id, nome, email, cpf, telefone, salario, cargo, data_admissao) VALUES
(1, 'Ana Silva', 'ana@empresa.com', '123.456.789-01', '(11) 99999-8888', 8500.00, 'Gerente de TI', '2020-03-10'),
(1, 'Bruno Santos', 'bruno@empresa.com', '987.654.321-09', '(11) 98888-7777', 6500.00, 'Desenvolvedor', '2021-07-15'),
(2, 'Carla Ferreira', 'carla@empresa.com', '456.789.123-45', '(11) 97777-6666', 5500.00, 'Analista RH', '2019-01-20'),
(3, 'Diego Costa', 'diego@empresa.com', '789.123.456-78', '(11) 96666-5555', 7200.00, 'Analista Financeiro', '2020-11-05'),
(4, 'Elena Rodrigues', 'elena@empresa.com', '321.654.987-32', '(11) 95555-4444', 4800.00, 'Marketing', '2022-06-18'),
(5, 'Fernando Gomes', 'fernando@empresa.com', '654.987.321-65', '(11) 94444-3333', 6800.00, 'Vendedor', '2021-09-22'),
(1, 'Gabriela Martins', 'gabriela@empresa.com', '987.321.654-98', '(11) 93333-2222', 5300.00, 'Analista de Sistemas', '2020-08-14');

-- Projetos
INSERT INTO projetos (nome, orcamento, data_inicio) VALUES
('Sistema de Gestão', 120000.00, '2024-01-15'),
('Site Nova Empresa', 80000.00, '2024-02-01'),
('App Mobile', 150000.00, '2024-03-10');

-- Alocações
INSERT INTO alocacao (funcionario_id, projeto_id, horas_semanais) VALUES
(1, 1, 20),
(2, 1, 30),
(2, 3, 10),
(5, 2, 25),
(7, 3, 15);

-- MENSAGEM FINAL

SELECT 'Base de dados criada com sucesso!' as mensagem;
SELECT 'ATENÇÃO: CPFs estão VISÍVEIS no banco!' as alerta;
SELECT 'Total de funcionários:' as info, COUNT(*) as quantidade FROM funcionarios;


-- NÍVEL 1: BÁSICO (Análise de Dados)

-- Query 1.1: Ver todos os funcionários
SELECT * FROM funcionarios;

-- Query 1.2: Ver funcionários por departamento
SELECT f.nome, f.cargo, d.nome as departamento
FROM funcionarios f
JOIN departamentos d ON f.dept_id = d.id;

-- Query 1.3: Contar funcionários em cada departamento
SELECT d.nome, COUNT(f.id) as total_funcionarios
FROM departamentos d
LEFT JOIN funcionarios f ON d.id = f.dept_id
GROUP BY d.nome
ORDER BY total_funcionarios DESC;

-- NÍVEL 2: INTERMEDIÁRIO (Análise de Dados)

-- Query 2.1: Salário médio por departamento
SELECT d.nome,
    ROUND(AVG(f.salario), 2) as salario_medio,
    COUNT(f.id) as qtde_funcionarios
FROM departamentos d
JOIN funcionarios f ON d.id = f.dept_id
GROUP BY d.nome
ORDER BY salario_medio DESC;

-- Query 2.2: Funcionários com maior salário
SELECT nome, cargo, salario
FROM funcionarios
ORDER BY salario DESC
LIMIT 5;

-- Query 2.3: Projetos e funcionários alocados
SELECT
    p.nome as projeto,
    f.nome as funcionario,
    a.horas_semanais,
    f.cargo
FROM projetos p
JOIN alocacao a ON p.id = a.projeto_id
JOIN funcionarios f ON a.funcionario_id = f.id
ORDER BY p.nome;

-- NÍVEL 3: AVANÇADO (Problemas de Segurança)

-- Query 3.1: Mostrar vulnerabilidade - CPFs visíveis
SELECT nome, cpf, email, telefone
FROM funcionarios
WHERE cpf IS NOT NULL;

-- Query 3.2: Dados sensíveis expostos
SELECT
    nome,
    CONCAT('CPF: ', cpf) as dado_sensivel,
    CONCAT('Salário: R$ ', FORMAT(salario, 2)) as info_financeira,
    telefone
FROM funcionarios;

-- Query 3.3: Relatório completo (muito perigoso!)
SELECT
    f.nome as Funcionario,
    f.cpf as CPF,
    f.email as Email,
    f.telefone as Telefone,
    f.salario as Salario,
    d.nome as Departamento,
    GROUP_CONCAT(p.nome) as Projetos
FROM funcionarios f
JOIN departamentos d ON f.dept_id = d.id
LEFT JOIN alocacao a ON f.id = a.funcionario_id
LEFT JOIN projetos p ON a.projeto_id = p.id
GROUP BY f.id;

-- NÍVEL 4: SOLUÇÕES DE SEGURANÇA (CORRIGIDO)

-- Query 4.1: Criar usuários com diferentes acessos
-- Usuário 1: Gerente (acesso total)
CREATE USER 'gerente_ti'@'localhost' IDENTIFIED BY 'Ger3nt3@2024!';
-- CORRIGIDO: usa empresaTop
GRANT ALL PRIVILEGES ON empresaTop.* TO 'gerente_ti'@'localhost';

-- Usuário 2: Analista (só consulta)
CREATE USER 'analista_rh'@'localhost' IDENTIFIED BY 'Anal1st@2024!';
-- CORRIGIDO: usa empresaTop
GRANT SELECT ON empresaTop.* TO 'analista_rh'@'localhost';

-- Usuário 3: Estagiário (só vê algumas colunas)
CREATE USER 'estagiario'@'localhost' IDENTIFIED BY 'Est4gi@2024!';

-- Concedendo acesso limitado ao estagiário (será complementado com VIEW)
-- CORRIGIDO: usa empresaTop
GRANT SELECT (id, nome, cargo) ON empresaTop.funcionarios TO 'estagiario'@'localhost';

-- Query 4.2: Verificar usuários criados
SELECT User, Host FROM mysql.user WHERE User LIKE '%empresa%' OR User IN ('gerente_ti', 'analista_rh', 'estagiario');

-- Ver permissões de um usuário
SHOW GRANTS FOR 'analista_rh'@'localhost';

-- Query 4.3: Testar acesso dos usuários

-- NÍVEL 5: CRIPTOGRAFIA (CORRIGIDO O ERRO 1175)

-- Query 5.1: Criar chave secreta
SET @chave_secreta = 'MinhaChave#2024Segura!';

-- Query 5.2: Criar nova coluna para CPF criptografado
ALTER TABLE funcionarios
ADD COLUMN cpf_criptografado VARBINARY(255) AFTER cpf;

-- ⚠️ DESABILITAR MODO SEGURO TEMPORARIAMENTE para a atualização em massa (Correção do Erro 1175)
SET SQL_SAFE_UPDATES = 0; 

-- Query 5.3: Criptografar CPFs existentes
UPDATE funcionarios
SET cpf_criptografado = AES_ENCRYPT(cpf, @chave_secreta)
WHERE cpf IS NOT NULL;

-- ✅ REABILITAR MODO SEGURO
SET SQL_SAFE_UPDATES = 1; 

-- Query 5.4: Ver dados criptografados vs visíveis
SELECT
    nome,
    cpf as "CPF VISÍVEL (PERIGO)",
    cpf_criptografado as "CPF CRIPTOGRAFADO (SEGURO)"
FROM funcionarios;

-- Query 5.5: Descriptografar (apenas com chave)
SET @chave_secreta = 'MinhaChave#2024Segura!';
SELECT
    nome,
    CAST(AES_DECRYPT(cpf_criptografado, @chave_secreta) AS CHAR) as cpf_descriptografado
FROM funcionarios;

-- NÍVEL 6: MASCARAMENTO DE DADOS (CORRIGIDO)

-- Query 6.1: Criar view segura para relatórios
CREATE VIEW funcionarios_publico AS
SELECT
    id,
    nome,
    -- Email mascarado: a***@empresa.com
    CONCAT(
        LEFT(email, 1),
        '***',
        SUBSTRING(email, LOCATE('@', email))
    ) as email_mascarado,
    -- Telefone mascarado: (11) 9****-****
    CONCAT(
        LEFT(telefone, 2),
        ') 9****-****'
    ) as telefone_mascarado,
    cargo,
    -- Faixa salarial (não valor exato)
    CASE
        WHEN salario < 5000 THEN 'Até R$ 5.000'
        WHEN salario BETWEEN 5000 AND 8000 THEN 'R$ 5.000 - 8.000'
        ELSE 'Acima de R$ 8.000'
    END as faixa_salario
FROM funcionarios;

-- Query 6.2: Usar a view segura
SELECT * FROM funcionarios_publico;

-- Dar acesso ao estagiário à view
-- CORRIGIDO: usa empresaTop
GRANT SELECT ON empresaTop.funcionarios_publico TO 'estagiario'@'localhost';

-- Query 6.3: View específica para RH
CREATE VIEW funcionarios_rh AS
SELECT
    f.id,
    f.nome,
    f.cpf, -- RH pode ver CPF (com responsabilidade)
    f.email,
    f.telefone,
    f.cargo,
    f.salario,
    d.nome as departamento
FROM funcionarios f
JOIN departamentos d ON f.dept_id = d.id;

-- NÍVEL 7: AUDITORIA BÁSICA

-- Query 7.1: Criar tabela de auditoria
CREATE TABLE auditoria_funcionarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100),
    funcionario_id INT,
    acao VARCHAR(10), -- INSERT, UPDATE, DELETE
    dados_antigos TEXT,
    dados_novos TEXT
);

-- Query 7.2: Trigger para auditoria de UPDATE
DELIMITER $$
CREATE TRIGGER audita_funcionario_update
AFTER UPDATE ON funcionarios
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_funcionarios (usuario, funcionario_id, acao, dados_antigos, dados_novos)
    VALUES (
        CURRENT_USER(),
        OLD.id,
        'UPDATE',
        CONCAT('Antigo salário: ', OLD.salario, ' | Cargo: ', OLD.cargo),
        CONCAT('Novo salário: ', NEW.salario, ' | Cargo: ', NEW.cargo)
    );
END$$
DELIMITER ;

-- Query 7.3: Testar o trigger
UPDATE funcionarios
SET salario = salario * 1.1
WHERE id = 2;

-- Ver a auditoria
SELECT * FROM auditoria_funcionarios;

-- Query 7.4: Trigger para DELETE
DELIMITER $$
CREATE TRIGGER audita_funcionario_delete
AFTER DELETE ON funcionarios
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_funcionarios (usuario, funcionario_id, acao, dados_antigos)
    VALUES (
        CURRENT_USER(),
        OLD.id,
        'DELETE',
        CONCAT('Excluiu: ', OLD.nome, ' - CPF: ', OLD.cpf)
    );
END$$
DELIMITER ;

-- NÍVEL 8: SEGURANÇA AVANÇADA (CORRIGIDO)

-- Query 8.1: Remover CPFs visíveis (depois de criptografar)
-- Primeiro, faça backup!
CREATE TABLE backup_cpfs AS
SELECT id, nome, cpf, cpf_criptografado FROM funcionarios;

-- ⚠️ DESABILITAR MODO SEGURO TEMPORARIAMENTE (Correção do Erro 1175)
SET SQL_SAFE_UPDATES = 0;

-- Agora apague os CPFs visíveis (ou coloque NULL)
UPDATE funcionarios SET cpf = NULL;

-- ✅ REABILITAR MODO SEGURO
SET SQL_SAFE_UPDATES = 1;

-- Verifique
SELECT nome, cpf, cpf_criptografado FROM funcionarios;

-- Query 8.2: Validação de dados na inserção
-- Trigger para validar dados antes de inserir
DELIMITER $$
CREATE TRIGGER valida_funcionario_insert
BEFORE INSERT ON funcionarios
FOR EACH ROW
BEGIN
    -- Validar email
    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Email inválido!';
    END IF;

    -- Validar salário mínimo
    IF NEW.salario < 1412.00 THEN -- (Ajuste para valor de referência atual)
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salário abaixo do mínimo!';
    END IF;

    -- Formatar telefone
    IF NEW.telefone IS NOT NULL THEN
        SET NEW.telefone = REPLACE(REPLACE(REPLACE(NEW.telefone, '(', ''), ')', ''), '-', '');
    END IF;
END$$
DELIMITER ;

-- Query 8.3: Testar validação
-- Isso deve FALHAR (email inválido)
INSERT INTO funcionarios (nome, email, salario)
VALUES ('Teste', 'emailinvalido', 1500.00);

-- Isso deve FALHAR (salário baixo)
INSERT INTO funcionarios (nome, email, salario)
VALUES ('Teste', 'teste@email.com', 1000.00);

-- Isso deve FUNCIONAR
INSERT INTO funcionarios (nome, email, salario, telefone)
VALUES ('Teste', 'teste@email.com', 2000.00, '(11) 99999-8888'); -- O telefone será formatado

-- NÍVEL 9: CONSULTAS COMPLEXAS DE MONITORAMENTO (CORRIGIDO)

-- Query 9.1: Dashboard de segurança
-- Monitorar atividades
SELECT
    'Funcionários' as categoria,
    COUNT(*) as total
FROM funcionarios
UNION ALL
SELECT
    'CPFs Criptografados',
    COUNT(*)
FROM funcionarios
WHERE cpf_criptografado IS NOT NULL
UNION ALL
SELECT
    'Eventos de Auditoria',
    COUNT(*)
FROM auditoria_funcionarios
UNION ALL
SELECT
    'Views de Segurança',
    COUNT(*)
FROM information_schema.views
-- CORRIGIDO: usa empresaTop
WHERE table_schema = 'empresaTop';

-- Query 9.2: Relatório de atividades recentes
-- O que aconteceu nas últimas 24h?
SELECT
    DATE(data_hora) as data,
    HOUR(data_hora) as hora,
    usuario,
    acao,
    COUNT(*) as quantidade
FROM auditoria_funcionarios
WHERE data_hora >= NOW() - INTERVAL 1 DAY
GROUP BY DATE(data_hora), HOUR(data_hora), usuario, acao
ORDER BY data DESC, hora DESC;

-- Query 9.3: Verificar vulnerabilidades
-- Consulta que mostra potenciais problemas
SELECT
    'CPFs ainda visíveis' as problema,
    COUNT(*) as quantidade
FROM funcionarios
WHERE cpf IS NOT NULL
UNION ALL
SELECT
    'Funcionários sem email',
    COUNT(*)
FROM funcionarios
WHERE email IS NULL OR email = ""
UNION ALL
SELECT
    'Salários abaixo do mercado',
    COUNT(*)
FROM funcionarios
WHERE salario < 2000;

-- NÍVEL 10: MANUTENÇÃO E LIMPEZA

-- Query 10.1: Backup dos dados sensíveis
-- Backup dos dados criptografados
CREATE TABLE backup_criptografia AS
SELECT
    id,
    nome,
    cpf_criptografado,
    SHA2(@chave_secreta, 256) as hash_chave,
    NOW() as data_backup
FROM funcionarios
WHERE cpf_criptografado IS NOT NULL;

-- Verificar backup
SELECT * FROM backup_criptografia;

-- Query 10.2: Limpar dados de teste
-- Remover usuários de teste
DROP USER IF EXISTS 'gerente_ti'@'localhost';
DROP USER IF EXISTS 'analista_rh'@'localhost';
DROP USER IF EXISTS 'estagiario'@'localhost';

-- Remover triggers (necessário redefinir o DELIMITER antes de dropar, dependendo do ambiente)
DELIMITER ;
DROP TRIGGER IF EXISTS audita_funcionario_update;
DROP TRIGGER IF EXISTS audita_funcionario_delete;
DROP TRIGGER IF EXISTS valida_funcionario_insert;

-- Remover views
DROP VIEW IF EXISTS funcionarios_publico;
DROP VIEW IF EXISTS funcionarios_rh;

-- Query 10.3: Reset para começar de novo
-- CUIDADO: Isso apaga tudo!
-- CORRIGIDO: usa empresaTop
DROP DATABASE IF EXISTS empresaTop;
CREATE DATABASE empresaTop;