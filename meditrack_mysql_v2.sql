-- 1. CRIA O BANCO DE DADOS E SELECIONA
CREATE DATABASE IF NOT EXISTS `meditrack` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `meditrack`;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_ENGINE_SUBSTITUTION";

-- --------------------------------------------------------
-- Limpeza das tabelas antigas (Garante execução limpa)
-- --------------------------------------------------------
DROP TABLE IF EXISTS `DoseEvent`;
DROP TABLE IF EXISTS `Prescription`;
DROP TABLE IF EXISTS `Professional`;
DROP TABLE IF EXISTS `Profile`;
DROP TABLE IF EXISTS `Resident`;
DROP TABLE IF EXISTS `User`;
DROP TABLE IF EXISTS `_prisma_migrations`;

-- --------------------------------------------------------
-- Tabela: User (Usuário)
-- --------------------------------------------------------
CREATE TABLE `User` (
    `id_usuario` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `role` VARCHAR(191) NOT NULL DEFAULT 'USER',
    PRIMARY KEY (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela: Resident (Residente)
-- --------------------------------------------------------
CREATE TABLE `Resident` (
    `id_residente` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `room` VARCHAR(191) NOT NULL,
    `bed` VARCHAR(191) DEFAULT NULL,
    `photo` VARCHAR(191) DEFAULT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`id_residente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela: Profile (Perfil do Usuário)
-- --------------------------------------------------------
CREATE TABLE `Profile` (
    `id_perfil` VARCHAR(191) NOT NULL,
    `initials` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `avatarCls` VARCHAR(191) DEFAULT NULL,
    `id_usuario` VARCHAR(191) NOT NULL,
    PRIMARY KEY (`id_perfil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela: Professional (Profissional de Saúde)
-- --------------------------------------------------------
CREATE TABLE `Professional` (
    `id_profissional` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `role` VARCHAR(191) NOT NULL,
    `initials` VARCHAR(191) NOT NULL,
    `registry` VARCHAR(191) DEFAULT NULL,
    `email` VARCHAR(191) DEFAULT NULL,
    `phone` VARCHAR(191) DEFAULT NULL,
    `bio` TEXT DEFAULT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`id_profissional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela: Prescription (Prescrição / Receita)
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
-- Tabela: DoseEvent (Evento de Dosagem / Agenda)
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
-- Índices Otimizados
-- --------------------------------------------------------
CREATE UNIQUE INDEX `User_email_key` ON `User` (`email`);
CREATE UNIQUE INDEX `Profile_id_usuario_key` ON `Profile` (`id_usuario`);
CREATE INDEX `DoseEvent_id_prescricao_idx` ON `DoseEvent` (`id_prescricao`);
CREATE INDEX `DoseEvent_id_residente_idx` ON `DoseEvent` (`id_residente`);
CREATE INDEX `DoseEvent_scheduledFor_idx` ON `DoseEvent` (`scheduledFor`);

-- --------------------------------------------------------
-- Restrições de Chaves Estrangeiras (Constraints)
-- --------------------------------------------------------
ALTER TABLE `Profile`
    ADD CONSTRAINT `Profile_id_usuario_fkey` FOREIGN KEY (`id_usuario`) REFERENCES `User` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Prescription`
    ADD CONSTRAINT `Prescription_id_residente_fkey` FOREIGN KEY (`id_residente`) REFERENCES `Resident` (`id_residente`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `DoseEvent`
    ADD CONSTRAINT `DoseEvent_id_prescricao_fkey` FOREIGN KEY (`id_prescricao`) REFERENCES `Prescription` (`id_prescricao`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `DoseEvent_id_residente_fkey` FOREIGN KEY (`id_residente`) REFERENCES `Resident` (`id_residente`) ON DELETE CASCADE ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS = 1;