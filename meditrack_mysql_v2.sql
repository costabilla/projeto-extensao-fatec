-- 1. CONFIGURAÇÕES INICIAIS E CRIAÇÃO DO BANCO
CREATE DATABASE IF NOT EXISTS `meditrack` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `meditrack`;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_ENGINE_SUBSTITUTION";

-- --------------------------------------------------------
-- Limpeza radical e preventiva de todas as estruturas
-- --------------------------------------------------------
DROP TABLE IF EXISTS `DoseEvent`;
DROP TABLE IF EXISTS `Prescription`;
DROP TABLE IF EXISTS `Professional`;
DROP TABLE IF EXISTS `Profile`;
DROP TABLE IF EXISTS `Resident`;
DROP TABLE IF EXISTS `User`;

-- --------------------------------------------------------
-- Tabela: User (Níveis de Acesso ao Sistema: ADMIN ou USER)
-- --------------------------------------------------------
CREATE TABLE `User` (
    `id_usuario` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `role` VARCHAR(191) NOT NULL DEFAULT 'USER',
    PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela: Resident (Cadastro de Pacientes/Idosos)
-- --------------------------------------------------------
CREATE TABLE `Resident` (
    `id_residente` VARCHAR(191) NOT NULL,
    `nome_residente` VARCHAR(191) NOT NULL, -- Alterado para clareza
    `room` VARCHAR(191) NOT NULL,
    `bed` VARCHAR(191) DEFAULT NULL,
    `photo` VARCHAR(191) DEFAULT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`id_residente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela: Profile (Perfil do Usuário - Fonte Única do Nome da Equipe)
-- --------------------------------------------------------
CREATE TABLE `Profile` (
    `id_perfil` VARCHAR(191) NOT NULL,
    `initials` VARCHAR(191) NOT NULL,
    `nome_cuidador` VARCHAR(191) NOT NULL, -- Alterado para clareza
    `avatarCls` VARCHAR(191) DEFAULT NULL,
    `id_usuario` VARCHAR(191) NOT NULL,
    PRIMARY KEY (`id_perfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela: Professional (Ficha Clínica - Sem nome duplicado)
-- --------------------------------------------------------
CREATE TABLE `Professional` (
    `id_profissional` VARCHAR(191) NOT NULL,
    `especializacao` VARCHAR(191) NOT NULL,
    `initials` VARCHAR(191) NOT NULL,
    `registry` VARCHAR(191) DEFAULT NULL,
    `email` VARCHAR(191) DEFAULT NULL,
    `phone` VARCHAR(191) DEFAULT NULL,
    `bio` TEXT DEFAULT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `id_usuario` VARCHAR(191) NOT NULL, -- FK para buscar o 'nome_cuidador' no Profile
    PRIMARY KEY (`id_profissional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela: Prescription (Receitas e Aprazamentos Médicos)
-- --------------------------------------------------------
CREATE TABLE `Prescription` (
    `id_prescricao` VARCHAR(191) NOT NULL,
    `drug` TEXT NOT NULL,
    `drugIcon` VARCHAR(191) NOT NULL DEFAULT 'pill',
    `dose` TEXT NOT NULL,
    `frequency` TEXT NOT NULL,
    `times` JSON DEFAULT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'Ativa',
    `notes` TEXT DEFAULT NULL,
    `startDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `endDate` TIMESTAMP NULL DEFAULT NULL,
    `id_residente` VARCHAR(191) NOT NULL,
    PRIMARY KEY (`id_prescricao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela: DoseEvent (Controle e Histórico de Aplicação de Doses)
-- --------------------------------------------------------
CREATE TABLE `DoseEvent` (
    `id_evento` VARCHAR(191) NOT NULL,
    `scheduledFor` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` VARCHAR(191) NOT NULL DEFAULT 'pending',
    `administeredAt` TIMESTAMP NULL DEFAULT NULL,
    `id_prescricao` VARCHAR(191) NOT NULL,
    `id_residente` VARCHAR(191) NOT NULL,
    PRIMARY KEY (`id_evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Índices Otimizados e Chaves Estrangeiras (Constraints)
-- --------------------------------------------------------
CREATE UNIQUE INDEX `User_email_key` ON `User` (`email`);
CREATE UNIQUE INDEX `Profile_id_usuario_key` ON `Profile` (`id_usuario`);
CREATE UNIQUE INDEX `Professional_id_usuario_key` ON `Professional` (`id_usuario`);

ALTER TABLE `Profile` 
    ADD CONSTRAINT `Profile_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `User` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Professional` 
    ADD CONSTRAINT `Professional_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `User` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Prescription` 
    ADD CONSTRAINT `Prescription_id_residente_fkey` FOREIGN KEY (`id_residente`) REFERENCES `Resident` (`id_residente`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `DoseEvent` 
    ADD CONSTRAINT `DoseEvent_id_prescricao_fkey` FOREIGN KEY (`id_prescricao`) REFERENCES `Prescription` (`id_prescricao`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `DoseEvent_id_residente_fkey` FOREIGN KEY (`id_residente`) REFERENCES `Resident` (`id_residente`) ON DELETE CASCADE ON UPDATE CASCADE;

-- --------------------------------------------------------
-- 2. POPULAÇÃO DOS DADOS (Volume Extenso Ajustado)
-- --------------------------------------------------------

DELETE FROM `DoseEvent`;
DELETE FROM `Prescription`;
DELETE FROM `Resident`;
DELETE FROM `Professional`;
DELETE FROM `Profile`;
DELETE FROM `User`;

-- Inserindo Usuários (7 Contas)
INSERT INTO `User` (`id_usuario`, `email`, `password`, `role`) VALUES
('usr_01', 'diretoria@meditrack.com', 'hash_dir_123', 'ADMIN'),
('usr_02', 'fernanda.lima@meditrack.com', 'hash_fer_456', 'USER'),
('usr_03', 'marcos.santos@meditrack.com', 'hash_mar_789', 'USER'),
('usr_04', 'paula.souza@meditrack.com', 'hash_pau_abc', 'USER'),
('usr_05', 'ricardo.alves@meditrack.com', 'hash_ric_def', 'USER'),
('usr_06', 'carlos.eduardo@meditrack.com', 'hash_car_999', 'USER'),
('usr_07', 'admin.suporte@meditrack.com', 'hash_sup_xyz', 'ADMIN');

-- Inserindo Perfis (Usando 'nome_cuidador')
INSERT INTO `Profile` (`id_perfil`, `initials`, `nome_cuidador`, `avatarCls`, `id_usuario`) VALUES
('prf_01', 'DR', 'Diretoria Geral', 'bg-red-600', 'usr_01'),
('prf_02', 'FL', 'Fernanda Lima', 'bg-blue-500', 'usr_02'),
('prf_03', 'MS', 'Dr. Marcos Santos', 'bg-emerald-500', 'usr_03'),
('prf_04', 'PS', 'Paula Souza', 'bg-indigo-500', 'usr_04'),
('prf_05', 'RA', 'Dr. Ricardo Alves', 'bg-teal-500', 'usr_05'),
('prf_06', 'CE', 'Carlos Eduardo', 'bg-orange-500', 'usr_06'),
('prf_07', 'SU', 'Suporte Técnico', 'bg-gray-700', 'usr_07');

-- Inserindo Profissionais (Vinculados via id_usuario)
INSERT INTO `Professional` (`id_profissional`, `especializacao`, `initials`, `registry`, `email`, `phone`, `bio`, `active`, `id_usuario`) VALUES
('pro_01', 'Enfermagem Padrão', 'FL', 'COREN-SP 001.234', 'fernanda.lima@meditrack.com', '(11) 98888-0001', 'Supervisora do plantão diurno.', 1, 'usr_02'),
('pro_02', 'Geriatria', 'MS', 'CRM-SP 111.222', 'marcos.santos@meditrack.com', '(11) 98888-0002', 'Coordenador clínico da instituição.', 1, 'usr_03'),
('pro_03', 'Técnica de Enfermagem', 'PS', 'COREN-SP 005.678', 'paula.souza@meditrack.com', '(11) 98888-0003', 'Responsável pela ala B.', 1, 'usr_04'),
('pro_04', 'Psiquiatria Geriátrica', 'RA', 'CRM-SP 333.444', 'ricardo.alves@meditrack.com', '(11) 98888-0004', 'Consultor de saúde mental.', 1, 'usr_05'),
('pro_05', 'Fisioterapia Motora', 'CE', 'CREFITO-SP 99.88', 'carlos.eduardo@meditrack.com', '(11) 98888-0005', 'Atendimento terapêutico móvel.', 0, 'usr_06');

-- Inserindo Residentes (Usando 'nome_residente')
INSERT INTO `Resident` (`id_residente`, `nome_residente`, `room`, `bed`, `photo`, `active`) VALUES
('res_01', 'Dona Maria Oliveira', 'Quarto 101', 'Leito A', 'maria.jpg', 1),
('res_02', 'Seu José dos Santos', 'Quarto 101', 'Leito B', 'jose.jpg', 1),
('res_03', 'Dona Francisca Souza', 'Quarto 102', 'Leito A', NULL, 1),
('res_04', 'Seu Antônio Pereira', 'Quarto 103', 'Leito A', 'antonio.jpg', 1),
('res_05', 'Dona Alzira Mendes', 'Quarto 104', 'Leito A', NULL, 1),
('res_06', 'Seu Geraldo Alencar', 'Quarto 104', 'Leito B', 'geraldo.jpg', 1),
('res_07', 'Dona Nair Rodrigues', 'Quarto 105', 'Leito A', NULL, 1),
('res_08', 'Seu Walter Silva', 'Quarto 106', 'Leito A', 'walter.jpg', 0);

-- Inserindo Prescrições
INSERT INTO `Prescription` (`id_prescricao`, `drug`, `drugIcon`, `dose`, `frequency`, `times`, `status`, `notes`, `id_residente`) VALUES
('pre_01', 'Dipirona 500mg', 'pill', '1 comprimido', 'A cada 8 horas', '["06:00", "14:00", "22:00"]', 'Ativa', 'Apenas se apresentar febre > 37.8°C.', 'res_01'),
('pre_02', 'Losartana 50mg', 'pill', '1 comprimido', 'Uso Diário', '["08:00"]', 'Ativa', 'Aferir a pressão arterial antes de administrar.', 'res_01'),
('pre_03', 'Puran T4 50mcg', 'pill', '1 comprimido', 'Uso Diário', '["06:30"]', 'Ativa', 'Dar em jejum absoluto.', 'res_01'),
('pre_04', 'Metformina 850mg', 'pill', '1 comprimido', 'Uso Diário', '["12:00", "19:00"]', 'Ativa', 'Administrar imediatamente após o almoço e jantar.', 'res_02'),
('pre_05', 'Insulina NPH', 'syringe', '10 UI', 'Todas as manhãs', '["07:30"]', 'Ativa', 'Realizar teste de glicemia capilar antes.', 'res_02'),
('pre_06', 'Omeprazol 20mg', 'pill', '1 cápsula', 'Uso Diário', '["07:00"]', 'Ativa', 'Administrar 30 min antes do café da manhã.', 'res_03'),
('pre_07', 'Rivotril 2.5mg/mL', 'droplet', '5 gotas', 'Ao deitar', '["21:30"]', 'Ativa', 'Diluir em um pouco de água.', 'res_03'),
('pre_08', 'AAS Infantil 100mg', 'pill', '1 comprimido', 'Uso Diário', '["12:00"]', 'Ativa', 'Protetor cardiovascular.', 'res_04'),
('pre_09', 'Sinvastatina 20mg', 'pill', '1 comprimido', 'Uso Diário', '["20:00"]', 'Ativa', 'Dar no período da noite.', 'res_04'),
('pre_10', 'Paracetamol 500mg', 'pill', '1 comprimido', 'Se necessário', '["10:00", "16:00"]', 'Suspensa', 'Substituído por Dipirona.', 'res_05'),
('pre_11', 'Donepezila 5mg', 'pill', '1 comprimido', 'Uso Diário', '["21:00"]', 'Ativa', 'Tratamento de suporte cognitivo.', 'res_06'),
('pre_12', 'Sertralina 50mg', 'pill', '1 comprimido', 'Pela manhã', '["08:00"]', 'Ativa', 'Não interromper sem orientação.', 'res_07');

-- Inserindo Eventos
INSERT INTO `DoseEvent` (`id_evento`, `scheduledFor`, `status`, `administeredAt`, `id_prescricao`, `id_residente`) VALUES
('evt_01', '2026-05-22 06:30:00', 'administered', '2026-05-22 06:35:00', 'pre_03', 'res_01'),
('evt_02', '2026-05-22 08:00:00', 'pending', NULL, 'pre_02', 'res_01'),
('evt_03', '2026-05-22 14:00:00', 'pending', NULL, 'pre_01', 'res_01'),
('evt_04', '2026-05-22 07:30:00', 'administered', '2026-05-22 07:42:00', 'pre_05', 'res_02'),
('evt_05', '2026-05-22 12:00:00', 'pending', NULL, 'pre_04', 'res_02'),
('evt_06', '2026-05-22 07:00:00', 'administered', '2026-05-22 06:58:00', 'pre_06', 'res_03'),
('evt_07', '2026-05-22 21:30:00', 'pending', NULL, 'pre_07', 'res_03'),
('evt_08', '2026-05-22 12:00:00', 'pending', NULL, 'pre_08', 'res_04'),
('evt_09', '2026-05-22 20:00:00', 'pending', NULL, 'pre_09', 'res_04'),
('evt_10', '2026-05-22 08:00:00', 'pending', NULL, 'pre_12', 'res_07');

SET FOREIGN_KEY_CHECKS = 1;