-- 1. CRIA O BANCO DE DADOS E SELECIONA
CREATE DATABASE IF NOT EXISTS `meditrack` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `meditrack`;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_ENGINE_SUBSTITUTION";

-- --------------------------------------------------------
-- Table structure for DoseEvent
-- --------------------------------------------------------
DROP TABLE IF EXISTS `DoseEvent`;
CREATE TABLE `DoseEvent` (
    `id` VARCHAR(191) NOT NULL,
    `scheduledFor` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` VARCHAR(191) NOT NULL DEFAULT 'pending',
    `administeredAt` TIMESTAMP NULL DEFAULT NULL,
    `prescriptionId` VARCHAR(191) NOT NULL,
    `residentId` VARCHAR(191) NOT NULL,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for Prescription
-- --------------------------------------------------------
DROP TABLE IF EXISTS `Prescription`;
CREATE TABLE `Prescription` (
    `id` VARCHAR(191) NOT NULL,
    `drug` TEXT NOT NULL,
    `drugIcon` VARCHAR(191) NOT NULL DEFAULT 'pill',
    `dose` TEXT NOT NULL,
    `frequency` TEXT NOT NULL,
    `times` JSON DEFAULT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'Ativa',
    `notes` TEXT DEFAULT NULL,
    `startDate` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `endDate` TIMESTAMP NULL DEFAULT NULL,
    `residentId` VARCHAR(191) NOT NULL,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for Professional
-- --------------------------------------------------------
DROP TABLE IF EXISTS `Professional`;
CREATE TABLE `Professional` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `role` VARCHAR(191) NOT NULL,
    `initials` VARCHAR(191) NOT NULL,
    `registry` VARCHAR(191) DEFAULT NULL,
    `email` VARCHAR(191) DEFAULT NULL,
    `phone` VARCHAR(191) DEFAULT NULL,
    `bio` TEXT DEFAULT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for Profile
-- --------------------------------------------------------
DROP TABLE IF EXISTS `Profile`;
CREATE TABLE `Profile` (
    `id` VARCHAR(191) NOT NULL,
    `initials` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `avatarCls` VARCHAR(191) DEFAULT NULL,
    `userId` VARCHAR(191) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for Resident
-- --------------------------------------------------------
DROP TABLE IF EXISTS `Resident`;
CREATE TABLE `Resident` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `room` VARCHAR(191) NOT NULL,
    `bed` VARCHAR(191) DEFAULT NULL,
    `photo` VARCHAR(191) DEFAULT NULL,
    `active` TINYINT(1) NOT NULL DEFAULT 1,
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for User
-- --------------------------------------------------------
DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
    `id` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `role` VARCHAR(191) NOT NULL DEFAULT 'USER',
    `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Table structure for _prisma_migrations
-- --------------------------------------------------------
DROP TABLE IF EXISTS `_prisma_migrations`;
CREATE TABLE `_prisma_migrations` (
    `id` VARCHAR(36) NOT NULL,
    `checksum` VARCHAR(64) NOT NULL,
    `finished_at` TIMESTAMP NULL DEFAULT NULL,
    `migration_name` VARCHAR(255) NOT NULL,
    `logs` TEXT DEFAULT NULL,
    `rolled_back_at` TIMESTAMP NULL DEFAULT NULL,
    `started_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `applied_steps` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Indexes and Constraints
-- --------------------------------------------------------

CREATE INDEX `DoseEvent_prescriptionId_idx` ON `DoseEvent` (`prescriptionId`);
CREATE INDEX `DoseEvent_residentId_idx` ON `DoseEvent` (`residentId`);
CREATE INDEX `DoseEvent_scheduledFor_idx` ON `DoseEvent` (`scheduledFor`);
CREATE UNIQUE INDEX `Profile_userId_key` ON `Profile` (`userId`);
CREATE UNIQUE INDEX `User_email_key` ON `User` (`email`);

ALTER TABLE `DoseEvent`
    ADD CONSTRAINT `DoseEvent_prescriptionId_fkey` FOREIGN KEY (`prescriptionId`) REFERENCES `Prescription` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `DoseEvent_residentId_fkey` FOREIGN KEY (`residentId`) REFERENCES `Resident` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Prescription`
    ADD CONSTRAINT `Prescription_residentId_fkey` FOREIGN KEY (`residentId`) REFERENCES `Resident` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `Profile`
    ADD CONSTRAINT `Profile_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS = 1;