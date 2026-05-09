CREATE DATABASE casa_repouso;
USE casa_repouso;

-- =========================
-- TABELA BASE: PESSOA
-- =========================

CREATE TABLE Pessoa (
    id_pessoa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    funcao VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    rg VARCHAR(20) UNIQUE NOT NULL
);

-- =========================
-- PACIENTE
-- =========================

CREATE TABLE Paciente (
    id_paciente INT PRIMARY KEY,
    contato_emergencia VARCHAR(100),
    telefone_emergencia VARCHAR(20),

    CONSTRAINT fk_paciente_pessoa
        FOREIGN KEY (id_paciente)
        REFERENCES Pessoa(id_pessoa)
);

-- =========================
-- CUIDADOR
-- =========================

CREATE TABLE Cuidador (
    id_cuidador INT PRIMARY KEY,

    CONSTRAINT fk_cuidador_pessoa
        FOREIGN KEY (id_cuidador)
        REFERENCES Pessoa(id_pessoa)
);

-- =========================
-- ADMINISTRADOR
-- =========================

CREATE TABLE Administrador (
    id_adm INT PRIMARY KEY,

    CONSTRAINT fk_adm_pessoa
        FOREIGN KEY (id_adm)
        REFERENCES Pessoa(id_pessoa)
);

-- =========================
-- MEDICAMENTO
-- =========================

CREATE TABLE Medicamento (
    id_medicamento INT PRIMARY KEY AUTO_INCREMENT,
    nome_medicamento VARCHAR(100) NOT NULL,
    funcao VARCHAR(200),
    apelido_facilitador VARCHAR(100),
    imagem VARCHAR(255)
);

-- =========================
-- USO
-- =========================

CREATE TABLE Uso (
    id_uso INT PRIMARY KEY AUTO_INCREMENT,

    id_paciente INT NOT NULL,
    id_medicamento INT NOT NULL,

    CONSTRAINT fk_uso_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES Paciente(id_paciente),

    CONSTRAINT fk_uso_medicamento
        FOREIGN KEY (id_medicamento)
        REFERENCES Medicamento(id_medicamento)
);

-- =========================
-- HORARIOS
-- =========================

CREATE TABLE Horario_Uso (
    id_horario INT PRIMARY KEY AUTO_INCREMENT,

    horario TIME NOT NULL,

    id_uso INT NOT NULL,

    CONSTRAINT fk_horario_uso
        FOREIGN KEY (id_uso)
        REFERENCES Uso(id_uso)
);

-- =========================
-- CUIDADOR <-> PACIENTE
-- =========================

CREATE TABLE Cuidador_Paciente (
    id_cuidador INT,
    id_paciente INT,

    PRIMARY KEY (id_cuidador, id_paciente),

    CONSTRAINT fk_cp_cuidador
        FOREIGN KEY (id_cuidador)
        REFERENCES Cuidador(id_cuidador),

    CONSTRAINT fk_cp_paciente
        FOREIGN KEY (id_paciente)
        REFERENCES Paciente(id_paciente)
);

-- =========================
-- ADM <-> CUIDADOR
-- =========================

CREATE TABLE Adm_Cuidador (
    id_adm INT,
    id_cuidador INT,

    PRIMARY KEY (id_adm, id_cuidador),

    CONSTRAINT fk_ac_adm
        FOREIGN KEY (id_adm)
        REFERENCES Administrador(id_adm),

    CONSTRAINT fk_ac_cuidador
        FOREIGN KEY (id_cuidador)
        REFERENCES Cuidador(id_cuidador)
);