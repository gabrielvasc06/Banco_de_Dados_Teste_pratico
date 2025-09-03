CREATE DATABASE BancoPrincipal;
Use BancoPrincipal;

CREATE TABLE Agencias (
    idAgencia INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(150) NOT NULL
);


CREATE TABLE Funcionarios (
    idFuncionario INT PRIMARY KEY AUTO_INCREMENT,
    CPF VARCHAR(11) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(60) NOT NULL,
    agencia VARCHAR(70) NOT NULL,
    fk_Agencias_idAgencia INT
);

CREATE TABLE Contas (
    idCartao INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(70) NOT NULL,
    dataDeValidade DATE,
    limite DECIMAL(10,2) NOT NULL,
    status VARCHAR(80) NOT NULL,
    fk_Clientes_idCliente INT
);

CREATE TABLE Clientes (
    idCliente INT PRIMARY KEY,
    CPF VARCHAR(100) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    data_de_nascimento DATE,
    endereco VARCHAR(80) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(14) NOT NULL,
    fk_Agencias_idAgencia INT
);

CREATE TABLE Cartoes (
    idConta INT PRIMARY KEY auto_increment,
    tipo VARCHAR(80) NOT NULL,
    saldoAtual DECIMAL(10, 2) NOT NULL,
    dataDeAbertura DATE,
    status VARCHAR(80) NOT NULL,
    fk_Clientes_idCliente INT
);

CREATE TABLE Faturas (
    idFatura INT PRIMARY KEY AUTO_INCREMENT,
    CartaoAssociado VARCHAR(70) NOT NULL,
    dataDeVencimento DATE,
    valorTotal DECIMAL(10, 2) NOT NULL,
    status VARCHAR(60) NOT NULL,
    fk_Cartoes_idConta INT
);

CREATE TABLE Transacoes (
    idTransacao INT PRIMARY KEY auto_increment,
    contaOrigem VARCHAR(100) NOT NULL,
    contaDestino VARCHAR(100) NOT NULL,
    tipo VARCHAR(60) NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    data DATE,
    hora TIME,
    fk_Clientes_idCliente INT
);

CREATE TABLE Beneficiarios_Favorecidos (
    idBeneficiario INT PRIMARY KEY AUTO_INCREMENT,
    clienteCadastro VARCHAR(70) NOT NULL,
    nomeDoFavorecido VARCHAR(70) NOT NULL,
    CPF VARCHAR(14) NOT NULL,
    banco VARCHAR(60) NOT NULL,
    agencia VARCHAR(90) NOT NULL,
    conta VARCHAR(70) NOT NULL,
    fk_Clientes_idCliente INT,
    fk_Contas_idCartao INT
);

CREATE TABLE Emprestimos (
    idEmprestimo INT PRIMARY KEY AUTO_INCREMENT,
    clienteSolicitante VARCHAR(100) NOT NULL,
    valorTotal DECIMAL(10, 2) NOT NULL,
    taxadeJuros VARCHAR(50) NOT NULL,
    numParcelas VARCHAR(60) NOT NULL,
    datadeSolicitacao DATE,
    status VARCHAR(60) NOT NULL,
    fk_Clientes_idCliente INT
);

CREATE TABLE Investimentos (
    idInvestimento INT PRIMARY KEY AUTO_INCREMENT,
    cliente VARCHAR(70) NOT NULL,
    tipoDeProduto VARCHAR(80) NOT NULL,
    valorAplicado DECIMAL(10, 2) NOT NULL,
    datadeAplicacao DATE,
    rentabilidade VARCHAR(60) NOT NULL,
    fk_Clientes_idCliente INT
);

CREATE TABLE Parcelas_do_emprestimo (
    idNumParcela INT PRIMARY KEY AUTO_INCREMENT,
    valor DECIMAL(10, 2) NOT NULL,
    datadeVencimento DATE,
    datadePagamento DATE,
    fk_Emprestimos_idEmprestimo INT
);
 
ALTER TABLE Funcionarios ADD CONSTRAINT FK_Funcionarios_2
    FOREIGN KEY (fk_Agencias_idAgencia)
    REFERENCES Agencias (idAgencia)
    ON DELETE RESTRICT;
 
ALTER TABLE Contas ADD CONSTRAINT FK_Contas_2
    FOREIGN KEY (fk_Clientes_idCliente)
    REFERENCES Clientes (idCliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Clientes ADD CONSTRAINT FK_Clientes_2
    FOREIGN KEY (fk_Agencias_idAgencia)
    REFERENCES Agencias (idAgencia)
    ON DELETE RESTRICT;
 
ALTER TABLE Cartoes ADD CONSTRAINT FK_Cartoes_2
    FOREIGN KEY (fk_Clientes_idCliente)
    REFERENCES Clientes (idCliente)
    ON DELETE CASCADE;
 
ALTER TABLE Faturas ADD CONSTRAINT FK_Faturas_2
    FOREIGN KEY (fk_Cartoes_idConta)
    REFERENCES Cartoes (idConta)
    ON DELETE RESTRICT;
 
ALTER TABLE Transacoes ADD CONSTRAINT FK_Transacoes_2
    FOREIGN KEY (fk_Clientes_idCliente)
    REFERENCES Clientes (idCliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Beneficiarios_Favorecidos ADD CONSTRAINT FK_Beneficiarios_Favorecidos_2
    FOREIGN KEY (fk_Clientes_idCliente)
    REFERENCES Clientes (idCliente)
    ON DELETE CASCADE;
 
ALTER TABLE Beneficiarios_Favorecidos ADD CONSTRAINT FK_Beneficiarios_Favorecidos_3
    FOREIGN KEY (fk_Contas_idCartao)
    REFERENCES Contas (idCartao)
    ON DELETE RESTRICT;
 
ALTER TABLE Emprestimos ADD CONSTRAINT FK_Emprestimos_2
    FOREIGN KEY (fk_Clientes_idCliente)
    REFERENCES Clientes (idCliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Investimentos ADD CONSTRAINT FK_Investimentos_2
    FOREIGN KEY (fk_Clientes_idCliente)
    REFERENCES Clientes (idCliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Parcelas_do_emprestimo ADD CONSTRAINT FK_Parcelas_do_emprestimo_2
    FOREIGN KEY (fk_Emprestimos_idEmprestimo)
    REFERENCES Emprestimos (idEmprestimo)
    ON DELETE RESTRICT;
    
    DROP PROCEDURE IF EXISTS popula_clientes;
    
 DROP PROCEDURE IF EXISTS popula_clientes;
 
-- remove a procedure antiga, se existir
DROP PROCEDURE IF EXISTS popula_clientes;

DELIMITER $$

CREATE PROCEDURE popula_clientes()
BEGIN
  DECLARE i INT DEFAULT 1;

  WHILE i <= 100 DO
    INSERT INTO Clientes (idCliente, CPF, nome, data_de_nascimento, endereco, email, telefone, fk_Agencias_idAgencia)
    VALUES (
      i,
      LPAD(CAST(i AS CHAR), 11, '0'),                        -- CPF fictício (11 dígitos)
      CONCAT('Cliente ', i),                                 -- Nome fictício
      DATE_ADD('1970-01-01', INTERVAL FLOOR(RAND()*18000) DAY), -- Data de nascimento aleatória
      CONCAT('Rua Exemplo ', i, ', Cidade Fictícia'),        -- Endereço fictício
      CONCAT('cliente', i, '@exemplo.com'),                  -- Email fictício
      CONCAT('(11)9', LPAD(CAST(i AS CHAR), 7, '0')),        -- Telefone fictício
      FLOOR(1 + (RAND() * 5))                                -- fk_Agencias_idAgencia (1 a 5)
    );
    SET i = i + 1;
  END WHILE;
END$$

DELIMITER ;

CALL popula_clientes();
SELECT * FROM Clientes;


INSERT INTO Agencias (nome, endereco) VALUES
('Agência Central', 'Av. Paulista, 1000 - São Paulo/SP'),
('Agência Norte', 'Rua das Flores, 200 - Brasília/DF'),
('Agência Sul', 'Av. Borges de Medeiros, 150 - Porto Alegre/RS'),
('Agência Leste', 'Rua da Praia, 45 - Salvador/BA'),
('Agência Oeste', 'Av. das Américas, 2500 - Rio de Janeiro/RJ');

DELIMITER $$

CREATE PROCEDURE popular_funcionarios()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 100 DO
        INSERT INTO Funcionarios (CPF, nome, cargo, agencia, fk_Agencias_idAgencia)
        VALUES (
            LPAD(FLOOR(RAND() * 100000000000), 11, '0'),  -- CPF aleatório de 11 dígitos
            CONCAT('Funcionario_', i),                     -- Nome
            CONCAT('Cargo_', FLOOR(RAND() * 10) + 1),     -- Cargo aleatório
            CONCAT('Agencia_', FLOOR(RAND() * 50) + 1),   -- Agência aleatória
            FLOOR(RAND() * 10) + 1                         -- fk_Agencias_idAgencia aleatório
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL popular_funcionarios();
SELECT * FROM Funcionarios;

DELIMITER $$

CREATE PROCEDURE popular_contas()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Contas (tipo, dataDeValidade, limite, status, fk_Clientes_idCliente)
        VALUES (
            CONCAT('Tipo', FLOOR(1 + RAND()*5)), -- Tipo fictício entre Tipo1 e Tipo5
            DATE_ADD(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY), -- Data aleatória dentro do próximo ano
            ROUND(RAND()*10000, 2), -- Limite aleatório até 10.000
            IF(RAND() > 0.5, 'Ativa', 'Inativa'), -- Status Ativa ou Inativa
            FLOOR(1 + RAND()*50) -- idCliente aleatório entre 1 e 50
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL popular_contas();
SELECT * FROM Contas;


DELIMITER $$

CREATE PROCEDURE InserirCartoes()
BEGIN

    DECLARE i INT DEFAULT 1;
    DECLARE tipoCartao VARCHAR(80);
    DECLARE statusCartao VARCHAR(80);

  
    WHILE i <= 100 DO
        
        IF i % 2 = 0 THEN
            SET tipoCartao = 'credito';
        ELSE
            SET tipoCartao = 'debito';
        END IF;


        IF i % 3 = 0 THEN
            SET statusCartao = 'inativo';
        ELSE
            SET statusCartao = 'ativo';
        END IF;

  
        INSERT INTO Cartoes (tipo, saldoAtual, dataDeAbertura, status, fk_Clientes_idCliente)
        VALUES (
            tipoCartao,
            ROUND(RAND() * 5000 + 100, 2), -- saldoAtual aleatório entre 100 e 5100
            NOW() - INTERVAL FLOOR(RAND() * 365) DAY, -- dataDeAbertura aleatória nos últimos 365 dias
            statusCartao,
            (i % 20) + 1 -- fk_Clientes_idCliente aleatório entre 1 e 20
        );


        SET i = i + 1;
    END WHILE;
END$$


DELIMITER ;


CALL InserirCartoes();
SELECT * FROM Cartoes;

DELIMITER $$

-- Cria o procedimento armazenado que irá inserir os dados.
CREATE PROCEDURE InserirFaturas()
BEGIN
    -- Declara a variável para o contador do loop.
    DECLARE i INT DEFAULT 1;

    -- Inicia o loop que será executado 100 vezes.
    WHILE i <= 100 DO
        -- Insere um novo registro na tabela 'Faturas'.
        INSERT INTO Faturas (CartaoAssociado, dataDeVencimento, valorTotal, status, fk_Cartoes_idConta)
        VALUES (
            CONCAT('Cartao ', i),                                  -- Cartão associado fictício.
            CURDATE() + INTERVAL FLOOR(RAND() * 30) DAY,           -- Data de vencimento aleatória nos próximos 30 dias.
            ROUND(RAND() * 1000 + 10, 2),                          -- Valor total aleatório entre 10 e 1010.
            IF(RAND() > 0.5, 'Paga', 'Pendente'),                  -- Status aleatório: Paga ou Pendente.
            (i % 50) + 1                                           -- fk_Cartoes_idConta aleatória entre 1 e 50.
        );

        SET i = i + 1;
    END WHILE;
END$$


DELIMITER ;
CALL InserirFaturas();
SELECT * FROM Faturas

-- Define o delimitador para que o bloco de código seja executado como um todo.
DELIMITER $$

-- Cria o procedimento armazenado que irá inserir os dados.
CREATE PROCEDURE InserirTransacoes()
BEGIN
    -- Declara a variável para o contador do loop.
    DECLARE i INT DEFAULT 1;

    -- Inicia o loop que será executado 100 vezes.
    WHILE i <= 100 DO
        -- Insere um novo registro na tabela 'Transacoes'.
        INSERT INTO Transacoes (contaOrigem, contaDestino, tipo, valor, data, hora, fk_Clientes_idCliente)
        VALUES (
            CONCAT('ContaOrigem', i),                                  -- Conta de origem fictícia.
            CONCAT('ContaDestino', i % 10),                            -- Conta de destino fictícia.
            IF(RAND() > 0.5, 'Pagamento', 'Transferencia'),             -- Tipo aleatório: Pagamento ou Transferência.
            ROUND(RAND() * 500 + 1, 2),                                -- Valor aleatório entre 1 e 501.
            CURDATE(),                                                 -- Data da transação.
            CURTIME(),                                                 -- Hora da transação.
            (i % 20) + 1                                               -- fk_Clientes_idCliente aleatória entre 1 e 20.
        );

        -- Incrementa o contador do loop.
        SET i = i + 1;
    END WHILE;
END$$

-- Reseta o delimitador para o padrão.
DELIMITER ;

-- Chama o procedimento para executar o loop e inserir os 100 dados.
CALL InserirTransacoes();
SELECT * FROM Transacoes;



-- Define o delimitador para que o bloco de código seja executado como um todo.
DELIMITER $$

-- Cria o procedimento armazenado que irá inserir os dados.
CREATE PROCEDURE InserirBeneficiarios()
BEGIN
    -- Declara a variável para o contador do loop.
    DECLARE i INT DEFAULT 1;

    -- Inicia o loop que será executado 100 vezes.
    WHILE i <= 100 DO
        -- Insere um novo registro na tabela 'Beneficiarios_Favorecidos'.
        INSERT INTO Beneficiarios_Favorecidos (
            clienteCadastro, 
            nomeDoFavorecido, 
            CPF, 
            banco, 
            agencia, 
            conta, 
            fk_Clientes_idCliente, 
            fk_Contas_idCartao
        )
        VALUES (
            CONCAT('Cliente', i),                                       -- Cliente fictício.
            CONCAT('Favorecido', i),                                    -- Nome do favorecido fictício.
            LPAD(FLOOR(RAND() * 99999999999), 11, '0'),               -- CPF aleatório (11 dígitos).
            CONCAT('Banco', FLOOR(RAND() * 10) + 1),                    -- Banco aleatório.
            LPAD(FLOOR(RAND() * 9999), 4, '0'),                         -- Agência aleatória (4 dígitos).
            LPAD(FLOOR(RAND() * 999999), 6, '0'),                       -- Conta aleatória (6 dígitos).
            (i % 20) + 1,                                               -- fk_Clientes_idCliente aleatória entre 1 e 20.
            (i % 50) + 1                                                -- fk_Contas_idCartao aleatória entre 1 e 50.
        );

        -- Incrementa o contador do loop.
        SET i = i + 1;
    END WHILE;
END$$

-- Reseta o delimitador para o padrão.
DELIMITER ;

-- Chama o procedimento para executar o loop e inserir os 100 dados.
CALL InserirBeneficiarios();
SELECT * FROM Beneficiarios_Favorecidos;

-- Define o delimitador para que o bloco de código seja executado como um todo.
DELIMITER $$

-- Cria o procedimento armazenado que irá inserir os dados.
CREATE PROCEDURE InserirEmprestimos()
BEGIN
    -- Declara a variável para o contador do loop.
    DECLARE i INT DEFAULT 1;

    -- Inicia o loop que será executado 100 vezes.
    WHILE i <= 100 DO
        -- Insere um novo registro na tabela 'Emprestimos'.
        INSERT INTO Emprestimos (
            clienteSolicitante, 
            valorTotal, 
            taxadeJuros, 
            numParcelas, 
            datadeSolicitacao, 
            status, 
            fk_Clientes_idCliente
        )
        VALUES (
            CONCAT('Cliente', FLOOR(RAND() * 20) + 1),         -- Cliente fictício.
            ROUND(RAND() * 50000 + 1000, 2),                   -- Valor total aleatório entre 1000 e 51000.
            CONCAT(ROUND(RAND() * 15 + 1, 2), '%'),            -- Taxa de juros aleatória.
            CONCAT(FLOOR(RAND() * 24) + 6, 'x'),               -- Número de parcelas aleatório entre 6 e 30.
            CURDATE() - INTERVAL FLOOR(RAND() * 365) DAY,      -- Data de solicitação aleatória nos últimos 365 dias.
            IF(RAND() > 0.3, 'Aprovado', 'Pendente'),          -- Status aleatório: Aprovado ou Pendente.
            (i % 20) + 1                                       -- fk_Clientes_idCliente aleatória entre 1 e 20.
        );

        -- Incrementa o contador do loop.
        SET i = i + 1;
    END WHILE;
END$$

-- Reseta o delimitador para o padrão.
DELIMITER ;

-- Chama o procedimento para executar o loop e inserir os 100 dados.
CALL InserirEmprestimos();
SELECT * FROM Emprestimos;

-- Define o delimitador para que o bloco de código seja executado como um todo.
DELIMITER $$

-- Cria o procedimento armazenado que irá inserir os dados.
CREATE PROCEDURE InserirInvestimentos()
BEGIN
    -- Declara a variável para o contador do loop.
    DECLARE i INT DEFAULT 1;

    -- Inicia o loop que será executado 100 vezes.
    WHILE i <= 100 DO
        -- Insere um novo registro na tabela 'Investimentos'.
        INSERT INTO Investimentos (
            cliente, 
            tipoDeProduto, 
            valorAplicado, 
            datadeAplicacao, 
            rentabilidade, 
            fk_Clientes_idCliente
        )
        VALUES (
            CONCAT('Cliente', FLOOR(RAND() * 20) + 1),       -- Cliente fictício.
            CONCAT('Produto', FLOOR(RAND() * 5) + 1),        -- Tipo de produto aleatório (ex: Produto1, Produto2, etc.).
            ROUND(RAND() * 20000 + 500, 2),                   -- Valor aplicado aleatório entre 500 e 20500.
            CURDATE() - INTERVAL FLOOR(RAND() * 365) DAY,     -- Data de aplicação aleatória nos últimos 365 dias.
            CONCAT(ROUND(RAND() * 10, 2), '%'),              -- Rentabilidade aleatória (ex: 5.45%).
            (i % 20) + 1                                       -- fk_Clientes_idCliente aleatória entre 1 e 20.
        );

        -- Incrementa o contador do loop.
        SET i = i + 1;
    END WHILE;
END$$

-- Reseta o delimitador para o padrão.
DELIMITER ;

-- Chama o procedimento para executar o loop e inserir os 100 dados.
CALL InserirInvestimentos();
SELECT * FROM Investimentos;

-- Define o delimitador para que o bloco de código seja executado como um todo.
DELIMITER $$

-- Cria o procedimento armazenado que irá inserir os dados.
CREATE PROCEDURE InserirParcelas()
BEGIN
    -- Declara a variável para o contador do loop.
    DECLARE i INT DEFAULT 1;

    -- Inicia o loop que será executado 100 vezes.
    WHILE i <= 100 DO
        -- Insere um novo registro na tabela 'Parcelas_do_emprestimo'.
        INSERT INTO Parcelas_do_emprestimo (
            valor, 
            datadeVencimento, 
            datadePagamento, 
            fk_Emprestimos_idEmprestimo
        )
        VALUES (
            ROUND(RAND() * 2000 + 50, 2),                   -- Valor aleatório entre 50 e 2050.
            CURDATE() + INTERVAL FLOOR(RAND() * 365) DAY,     -- Data de vencimento aleatória no futuro.
            IF(RAND() > 0.5, CURDATE() + INTERVAL FLOOR(RAND() * 365) DAY, NULL), -- Data de pagamento opcional.
            (i % 10) + 1                                       -- fk_Emprestimos_idEmprestimo aleatória entre 1 e 10.
        );

        -- Incrementa o contador do loop.
        SET i = i + 1;
    END WHILE;
END$$

-- Reseta o delimitador para o padrão.
DELIMITER ;

-- Chama o procedimento para executar o loop e inserir os 100 dados.
CALL InserirParcelas();
SELECT * FROM Parcelas_do_emprestimo; 

