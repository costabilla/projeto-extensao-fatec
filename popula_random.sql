USE `meditrack`;

SET FOREIGN_KEY_CHECKS = 0;

-- Usando DELETE FROM para esvaziar as tabelas sem disparar o erro #1701
DELETE FROM `DoseEvent`;
DELETE FROM `Prescription`;
DELETE FROM `Resident`;
DELETE FROM `Professional`;
DELETE FROM `Profile`;
DELETE FROM `User`;

-- 1. POPULANDO A TABELA User
INSERT INTO `User` (`id`, `email`, `password`, `role`, `createdAt`, `updatedAt`) VALUES
('usr_01', 'admin@meditrack.com', 'senha_hash_admin', 'ADMIN', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('usr_02', 'enfermeira.ana@meditrack.com', 'senha_hash_ana', 'USER', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('usr_03', 'medico.carlos@meditrack.com', 'senha_hash_carlos', 'USER', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 2. POPULANDO A TABELA Profile (Vinculada a User)
INSERT INTO `Profile` (`id`, `initials`, `name`, `avatarCls`, `userId`) VALUES
('prf_01', 'AD', 'Administrador do Sistema', 'bg-red-500', 'usr_01'),
('prf_02', 'AS', 'Ana Silva', 'bg-blue-500', 'usr_02'),
('prf_03', 'CR', 'Carlos Rocha', 'bg-green-500', 'usr_03');

-- 3. POPULANDO A TABELA Professional
INSERT INTO `Professional` (`id`, `name`, `role`, `initials`, `registry`, `email`, `phone`, `bio`, `active`, `createdAt`, `updatedAt`) VALUES
('pro_01', 'Ana Silva', 'Enfermeira Chefe', 'AS', 'COREN-SP 123456', 'enfermeira.ana@meditrack.com', '(11) 99999-1111', 'Especialista em geriatria com 10 anos de experiência.', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('pro_02', 'Dr. Carlos Rocha', 'Médico Plantonista', 'CR', 'CRM-SP 654321', 'medico.carlos@meditrack.com', '(11) 99999-2222', 'Médico geriatra responsável pelas rotinas clínicas.', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 4. POPULANDO A TABELA Resident
INSERT INTO `Resident` (`id`, `name`, `room`, `bed`, `photo`, `active`, `createdAt`, `updatedAt`) VALUES
('res_01', 'Dona Maria Oliveira', 'Quarto 101', 'Leito A', 'maria_oliveira.jpg', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('res_02', 'Seu José dos Santos', 'Quarto 102', 'Leito B', 'jose_santos.jpg', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('res_03', 'Dona Francisca Souza', 'Quarto 105', 'Leito A', NULL, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 5. POPULANDO A TABELA Prescription (Vinculada a Resident)
INSERT INTO `Prescription` (`id`, `drug`, `drugIcon`, `dose`, `frequency`, `times`, `status`, `notes`, `startDate`, `endDate`, `residentId`, `createdAt`, `updatedAt`) VALUES
('pre_01', 'Dipirona 500mg', 'pill', '1 comprimido', 'A cada 8 horas', '["06:00", "14:00", "22:00"]', 'Ativa', 'Dar somente em caso de febre ou dor de cabeça.', CURRENT_TIMESTAMP, NULL, 'res_01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('pre_02', 'Losartana 500mg', 'pill', '1 comprimido', 'Uso Diário', '["08:00"]', 'Ativa', 'Verificar pressão arterial antes de administrar.', CURRENT_TIMESTAMP, NULL, 'res_01', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('pre_03', 'Metformina 850mg', 'pill', '1 comprimido', 'Uso Diário', '["12:00"]', 'Ativa', 'Administrar junto com o almoço.', CURRENT_TIMESTAMP, NULL, 'res_02', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('pre_04', 'Omeprazol 20mg', 'pill', '1 cápsula', 'Uso Diário', '["07:00"]', 'Ativa', 'Administrar em jejum.', CURRENT_TIMESTAMP, NULL, 'res_03', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 6. POPULANDO A TABELA DoseEvent (Vinculada a Prescription e Resident)
INSERT INTO `DoseEvent` (`id`, `scheduledFor`, `status`, `administeredAt`, `prescriptionId`, `residentId`, `createdAt`) VALUES
('evt_01', CURRENT_TIMESTAMP, 'pending', NULL, 'pre_01', 'res_01', CURRENT_TIMESTAMP),
('evt_02', CURRENT_TIMESTAMP, 'pending', NULL, 'pre_03', 'res_02', CURRENT_TIMESTAMP);

SET FOREIGN_KEY_CHECKS = 1;