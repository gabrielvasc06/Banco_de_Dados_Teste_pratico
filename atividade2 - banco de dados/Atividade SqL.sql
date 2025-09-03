CREATE DATABASE SenaiPE;
Use SenaiPE;

CREATE TABLE Alunos (
    idMatricula INT PRIMARY KEY NOT NULL,
    CPF VARCHAR(11) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE,
    email VARCHAR(150) NOT NULL,
    telefone VARCHAR(150) NOT NULL,
    data_ingresso DATE,
    fk_Turmas_idTurma INT,
    nota_final DECIMAL,
    frequencia DECIMAL
);

CREATE TABLE Professores (
    idProfessor INT PRIMARY KEY NOT NULL,
    CPF VARCHAR(11) NOT NULL ,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    maior_titulacao VARCHAR(150) NOT NULL
);

CREATE TABLE Disciplinas (
    idDisciplina INT PRIMARY KEY NOT NULL,
    nome VARCHAR(100) NOT NULL,
    carga_horaria INT,
    ementa VARCHAR(150) NOT NULL
);

CREATE TABLE Cursos (
    idCurso INT PRIMARY KEY NOT NULL,
    nomeCurso VARCHAR(150) NOT NULL,
    d_semestre INT,
    profCurso VARCHAR(150) NOT NULL,
    fk_Disciplinas_idDisciplina INT
);

CREATE TABLE Turmas (
    idTurma INT PRIMARY KEY NOT NULL,
    ano_semestre VARCHAR(150) NOT NULL,
    horario TIME,
    sala VARCHAR(150) NOT NULL
);

CREATE TABLE Contem (
    fk_Cursos_idCurso INT,
    fk_Alunos_idMatricula INT
);

CREATE TABLE Administrado (
    fk_Cursos_idCurso INT,
    fk_Professores_idProfessor INT
);
 
ALTER TABLE Alunos ADD CONSTRAINT FK_Alunos_2
    FOREIGN KEY (fk_Turmas_idTurma)
    REFERENCES Turmas (idTurma)
    ON DELETE RESTRICT;
 
ALTER TABLE Cursos ADD CONSTRAINT FK_Cursos_2
    FOREIGN KEY (fk_Disciplinas_idDisciplina)
    REFERENCES Disciplinas (idDisciplina)
    ON DELETE RESTRICT;
 
ALTER TABLE Contem ADD CONSTRAINT FK_Contem_1
    FOREIGN KEY (fk_Cursos_idCurso)
    REFERENCES Cursos (idCurso)
    ON DELETE RESTRICT;
 
ALTER TABLE Contem ADD CONSTRAINT FK_Contem_2
    FOREIGN KEY (fk_Alunos_idMatricula)
    REFERENCES Alunos (idMatricula)
    ON DELETE RESTRICT;
 
ALTER TABLE Administrado ADD CONSTRAINT FK_Administrado_1
    FOREIGN KEY (fk_Cursos_idCurso)
    REFERENCES Cursos (idCurso)
    ON DELETE RESTRICT;
 
ALTER TABLE Administrado ADD CONSTRAINT FK_Administrado_2
    FOREIGN KEY (fk_Professores_idProfessor)
    REFERENCES Professores (idProfessor)
    ON DELETE RESTRICT;
    
    
    DELIMITER $$

CREATE PROCEDURE InserirAlunosFicticios()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Alunos (
            idMatricula,
            CPF,
            nome,
            data_nascimento,
            email,
            telefone,
            data_ingresso,
            fk_Turmas_idTurma,
            nota_final,
            frequencia
        )
        VALUES (
            i,
            LPAD(FLOOR(RAND() * 99999999999), 11, '0'),        -- CPF fictício numérico com 11 dígitos
            CONCAT('Aluno ', i),                               -- Nome fictício simples
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*10000) DAY), -- Data de nascimento aleatória
            CONCAT('aluno', i, '@exemplo.com'),                -- Email fictício
            CONCAT('119', LPAD(FLOOR(RAND()*99999999), 8, '0')),  -- Telefone fictício
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*1000) DAY), -- Data de ingresso aleatória
            FLOOR(RAND()*10) + 1,                              -- fk_Turmas_idTurma (assumindo valores 1-10)
            ROUND(RAND()*10, 2),                               -- nota_final entre 0 e 10 com duas casas decimais
            ROUND(RAND()*100, 2)                               -- frequencia entre 0 e 100
        );
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;
CALL InserirAlunosFicticios();
SELECT * FROM Alunos;

DELIMITER $$

CREATE PROCEDURE inserirProfessores()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Professores (idProfessor, CPF, nome, email, maior_titulacao)
        VALUES (
            i,
            LPAD(i, 11, '0'), -- CPF fictício, apenas números com padding para 11 dígitos
            CONCAT('Professor ', i),
            CONCAT('professor', i, '@exemplo.com'),
            CASE 
                WHEN i % 3 = 0 THEN 'Doutorado'
                WHEN i % 3 = 1 THEN 'Mestrado'
                ELSE 'Especialização'
            END
        );
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

-- Para executar o procedimento e inserir os dados:
CALL inserirProfessores();
SELECT * FROM Professores;

DELIMITER $$

CREATE PROCEDURE InserirDisciplinas()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 100 DO
        INSERT INTO Disciplinas (idDisciplina, nome, carga_horaria, ementa)
        VALUES (
            i,
            CONCAT('Disciplina ', i),
            FLOOR(20 + RAND() * 60),  -- carga horária entre 20 e 80
            CONCAT('Ementa da disciplina ', i)
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Chamar o procedimento para inserir os dados
CALL InserirDisciplinas();
SELECT * FROM Disciplinas;

DELIMITER $$

CREATE PROCEDURE InserirCursos()
BEGIN
  DECLARE i INT DEFAULT 1;
  
  WHILE i <= 100 DO
    INSERT INTO Cursos (idCurso, nomeCurso, d_semestre, profCurso, fk_Disciplinas_idDisciplina)
    VALUES (
      i,
      CONCAT('Curso ', i),
      (i MOD 8) + 1, -- semestre de 1 a 8
      CONCAT('Professor ', i),
      i -- fk_Disciplinas_idDisciplina pode ser o mesmo i para exemplo
    );
    
    SET i = i + 1;
  END WHILE;
END $$

DELIMITER ;

-- Executar o procedimento para inserir os dados
CALL InserirCursos();
SELECT * FROM Cursos;

DELIMITER $$

CREATE PROCEDURE InserirTurmas()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Turmas (idTurma, ano_semestre, horario, sala)
        VALUES (
            i,
            CONCAT('20', LPAD(FLOOR(RAND() * 24), 2, '0'), '_', FLOOR(1 + RAND() * 2)), -- Exemplo: "2023_1" ou "2019_2"
            SEC_TO_TIME(FLOOR(RAND() * 24) * 3600 + FLOOR(RAND() * 60) * 60), -- Horário aleatório HH:MM:SS
            CONCAT('Sala ', FLOOR(1 + RAND() * 20)) -- Exemplo: "Sala 7"
        );
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

-- Executa o procedimento para inserir os dados
CALL InserirTurmas();
SELECT * FROM Turmas;