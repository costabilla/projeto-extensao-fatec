USE `meditrack`;

SET FOREIGN_KEY_CHECKS = 0;

-- Limpeza prévia dos dados para evitar conflitos de ID
DELETE FROM `DoseEvent`;
DELETE FROM `Prescription`;
DELETE FROM `Resident`;
DELETE FROM `Professional`;
DELETE FROM `Profile`;
DELETE FROM `User`;

-- --------------------------------------------------------
-- 1. POPULANDO A TABELA: User (6 Usuários)
-- --------------------------------------------------------
INSERT INTO `User` (`id_usuario`, `email`, `password`, `role`) VALUES
('usr_01', 'diretoria@meditrack.com', 'hash_dir_123', 'ADMIN'),
('usr_02', 'fernanda.lima@meditrack.com', 'hash_fer_456', 'USER'),
('usr_03', 'marcos.santos@meditrack.com', 'hash_mar_789', 'USER'),
('usr_04', 'paula.souza@meditrack.com', 'hash_pau_abc', 'USER'),
('usr_05', 'ricardo.alves@meditrack.com', 'hash_ric_def', 'USER'),
('usr_06', 'admin.suporte@meditrack.com', 'hash_sup_xyz', 'ADMIN');

-- --------------------------------------------------------
-- 2. POPULANDO A TABELA: Profile (Viculada a User)
-- --------------------------------------------------------
INSERT INTO `Profile` (`id_perfil`, `initials`, `name`, `avatarCls`, `id_usuario`) VALUES
('prf_01', 'DR', 'Diretoria Geral', 'bg-red-600', 'usr_01'),
('prf_02', 'FL', 'Fernanda Lima (Enf)', 'bg-blue-500', 'usr_02'),
('prf_03', 'MS', 'Dr. Marcos Santos', 'bg-emerald-500', 'usr_03'),
('prf_04', 'PS', 'Paula Souza (Téc)', 'bg-indigo-500', 'usr_04'),
('prf_05', 'RA', 'Dr. Ricardo Alves', 'bg-teal-500', 'usr_05'),
('prf_06', 'SU', 'Suporte Técnico', 'bg-gray-700', 'usr_06');

-- --------------------------------------------------------
-- 3. POPULANDO A TABELA: Professional (Corpo Clínico)
-- --------------------------------------------------------
INSERT INTO `Professional` (`id_profissional`, `name`, `role`, `initials`, `registry`, `email`, `phone`, `bio`, `active`) VALUES
('pro_01', 'Fernanda Lima', 'Enfermeira Padrão', 'FL', 'COREN-SP 001.234', 'fernanda.lima@meditrack.com', '(11) 98888-0001', 'Supervisora do plantão diurno.', 1),
('pro_02', 'Dr. Marcos Santos', 'Médico Geriatra', 'MS', 'CRM-SP 111.222', 'marcos.santos@meditrack.com', '(11) 98888-0002', 'Coordenador clínico da instituição.', 1),
('pro_03', 'Paula Souza', 'Técnica de Enfermagem', 'PS', 'COREN-SP 005.678', 'paula.souza@meditrack.com', '(11) 98888-0003', 'Responsável pela ala B.', 1),
('pro_04', 'Dr. Ricardo Alves', 'Médico Psiquiatra', 'RA', 'CRM-SP 333.444', 'ricardo.alves@meditrack.com', '(11) 98888-0004', 'Consultor de saúde mental.', 1),
('pro_05', 'Carlos Eduardo', 'Fisioterapeuta', 'CE', 'CREFITO-SP 99.88', 'carlos.edu@meditrack.com', '(11) 98888-0005', 'Atendimento terapêutico móvel.', 0); -- Inativo para testes

-- --------------------------------------------------------
-- 4. POPULANDO A TABELA: Resident (8 Idosos/Pacientes)
-- --------------------------------------------------------
INSERT INTO `Resident` (`id_residente`, `name`, `room`, `bed`, `photo`, `active`) VALUES
('res_01', 'Dona Maria Oliveira', 'Quarto 101', 'Leito A', 'maria.jpg', 1),
('res_02', 'Seu José dos Santos', 'Quarto 101', 'Leito B', 'jose.jpg', 1),
('res_03', 'Dona Francisca Souza', 'Quarto 102', 'Leito A', NULL, 1),
('res_04', 'Seu Antônio Pereira', 'Quarto 103', 'Leito A', 'antonio.jpg', 1),
('res_05', 'Dona Alzira Mendes', 'Quarto 104', 'Leito A', NULL, 1),
('res_06', 'Seu Geraldo Alencar', 'Quarto 104', 'Leito B', 'geraldo.jpg', 1),
('res_07', 'Dona Nair Rodrigues', 'Quarto 105', 'Leito A', NULL, 1),
('res_08', 'Seu Walter Silva', 'Quarto 106', 'Leito A', 'walter.jpg', 0); -- Inativo para testes

-- --------------------------------------------------------
-- 5. POPULANDO A TABELA: Prescription (Variedade de Receitas)
-- --------------------------------------------------------
INSERT INTO `Prescription` (`id_prescricao`, `drug`, `drugIcon`, `dose`, `frequency`, `times`, `status`, `notes`, `startDate`, `endDate`, `id_residente`) VALUES
-- Prescrições Dona Maria (res_01)
('pre_01', 'Dipirona 500mg', 'pill', '1 comprimido', 'A cada 8 horas', '["06:00", "14:00", "22:00"]', 'Ativa', 'Apenas se apresentar febre > 37.8°C.', CURRENT_TIMESTAMP, NULL, 'res_01'),
('pre_02', 'Losartana 50mg', 'pill', '1 comprimido', 'Uso Diário', '["08:00"]', 'Ativa', 'Aferir a pressão arterial antes de administrar.', CURRENT_TIMESTAMP, NULL, 'res_01'),
('pre_03', 'Puran T4 50mcg', 'pill', '1 comprimido', 'Uso Diário', '["06:30"]', 'Ativa', 'Dar em jejum absoluto.', CURRENT_TIMESTAMP, NULL, 'res_01'),

-- Prescrições Seu José (res_02)
('pre_04', 'Metformina 850mg', 'pill', '1 comprimido', 'Uso Diário', '["12:00", "19:00"]', 'Ativa', 'Administrar imediatamente após o almoço e jantar.', CURRENT_TIMESTAMP, NULL, 'res_02'),
('pre_05', 'Insulina NPH', 'syringe', '10 UI', 'Todas as manhãs', '["07:30"]', 'Ativa', 'Realizar teste de glicemia capilar antes.', CURRENT_TIMESTAMP, NULL, 'res_02'),

-- Prescrições Dona Francisca (res_03)
('pre_06', 'Omeprazol 20mg', 'pill', '1 cápsula', 'Uso Diário', '["07:00"]', 'Ativa', 'Administrar 30 min antes do café da manhã.', CURRENT_TIMESTAMP, NULL, 'res_03'),
('pre_07', 'Rivotril 2.5mg/mL', 'droplet', '5 gotas', 'Ao deitar', '["21:30"]', 'Ativa', 'Diluir em um pouco de água.', CURRENT_TIMESTAMP, NULL, 'res_03'),

-- Prescrições Seu Antônio (res_04)
('pre_08', 'AAS Infantil 100mg', 'pill', '1 comprimido', 'Uso Diário', '["12:00"]', 'Ativa', 'Protetor cardiovascular.', CURRENT_TIMESTAMP, NULL, 'res_04'),
('pre_09', 'Sinvastatina 20mg', 'pill', '1 comprimido', 'Uso Diário', '["20:00"]', 'Ativa', 'Dar no período da noite.', CURRENT_TIMESTAMP, NULL, 'res_04'),

-- Prescrições Dona Alzira (res_05)
('pre_10', 'Paracetamol 500mg', 'pill', '1 comprimido', 'Se necessário', '["10:00", "16:00"]', 'Suspensa', 'Trocar por Dipirona caso haja dores persistentes.', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'res_05'),

-- Prescrições Seu Geraldo (res_06)
('pre_11', 'Donepezila 5mg', 'pill', '1 comprimido', 'Uso Diário', '["21:00"]', 'Ativa', 'Tratamento de suporte cognitivo.', CURRENT_TIMESTAMP, NULL, 'res_06'),

-- Prescrições Dona Nair (res_07)
('pre_12', 'Sertralina 50mg', 'pill', '1 comprimido', 'Pela manhã', '["08:00"]', 'Ativa', 'Não interromper sem orientação.', CURRENT_TIMESTAMP, NULL, 'res_07');

-- --------------------------------------------------------
-- 6. POPULANDO A TABELA: DoseEvent (Cenários Variados)
-- --------------------------------------------------------
INSERT INTO `DoseEvent` (`id_evento`, `scheduledFor`, `status`, `administeredAt`, `id_prescricao`, `id_residente`) VALUES
-- Remédios da Dona Maria (Um aplicado, um pendente, um futuro)
('evt_01', '2026-05-22 06:30:00', 'administered', '2026-05-22 06:35:00', 'pre_03', 'res_01'), -- Puran aplicado
('evt_02', '2026-05-22 08:00:00', 'pending', NULL, 'pre_02', 'res_01'),                  -- Losartana aguardando
('evt_03', '2026-05-22 14:00:00', 'pending', NULL, 'pre_01', 'res_01'),                  -- Dipirona da tarde

-- Remédios do Seu José
('evt_04', '2026-05-22 07:30:00', 'administered', '2026-05-22 07:42:00', 'pre_05', 'res_02'), -- Insulina aplicada
('evt_05', '2026-05-22 12:00:00', 'pending', NULL, 'pre_04', 'res_02'),                  -- Metformina aguardando

-- Remédios da Dona Francisca
('evt_06', '2026-05-22 07:00:00', 'administered', '2026-05-22 06:58:00', 'pre_06', 'res_03'), -- Omeprazol aplicado adiantado
('evt_07', '2026-05-22 21:30:00', 'pending', NULL, 'pre_07', 'res_03'),                  -- Rivotril da noite

-- Remédios do Seu Antônio
('evt_08', '2026-05-22 12:00:00', 'pending', NULL, 'pre_08', 'res_04'),                  -- AAS aguardando
('evt_09', '2026-05-22 20:00:00', 'pending', NULL, 'pre_09', 'res_04'),                  -- Sinvastatina futura

-- Remédios da Dona Nair
('evt_10', '2026-05-22 08:00:00', 'pending', NULL, 'pre_12', 'res_07');                  -- Sertralina aguardando

SET FOREIGN_KEY_CHECKS = 1;