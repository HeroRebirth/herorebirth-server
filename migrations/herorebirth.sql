-- =====================================================
-- DATABASE: herorebirth
-- =====================================================

CREATE DATABASE IF NOT EXISTS `herorebirth` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `herorebirth`;

-- =====================================================
-- TABLE: users
-- Stores login credentials, account info, and NCash
-- =====================================================
CREATE TABLE IF NOT EXISTS `users` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL DEFAULT (UUID()),
  `user_name` VARCHAR(50) UNIQUE NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `user_type` TINYINT NOT NULL DEFAULT 0,
  `ip` VARCHAR(45),
  `server` INT DEFAULT -1,
  `ncash` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `bank_gold` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `mail` VARCHAR(255),
  `created_at` TIMESTAMP NULL,
  `disabled_until` TIMESTAMP NULL,
  `loginfrompanel` BOOLEAN DEFAULT FALSE,
  KEY `idx_user_name` (`user_name`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: cash
-- Stores NCash wallet information
-- =====================================================
CREATE TABLE IF NOT EXISTS `cash` (
  `id` VARCHAR(36) PRIMARY KEY NOT NULL,
  `amount` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: characters
-- Stores all player character data
-- =====================================================
CREATE TABLE IF NOT EXISTS `characters` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `user_id` VARCHAR(36) NOT NULL,
  `name` VARCHAR(50) UNIQUE NOT NULL,
  `epoch` BIGINT NOT NULL,
  `type` INT NOT NULL,
  `faction` INT NOT NULL DEFAULT 0,
  `height` INT NOT NULL DEFAULT 0,
  `level` INT NOT NULL DEFAULT 1,
  `class` INT NOT NULL DEFAULT 0,
  `is_online` BOOLEAN DEFAULT FALSE,
  `is_active` BOOLEAN DEFAULT TRUE,
  `gold` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `coordinate` VARCHAR(50) NOT NULL DEFAULT '(0,0)',
  `map` SMALLINT NOT NULL DEFAULT 0,
  `exp` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `ht_visibility` INT NOT NULL DEFAULT 0,
  `weapon_slot` INT NOT NULL DEFAULT 0,
  `running_speed` DOUBLE NOT NULL DEFAULT 1.0,
  `guild_id` INT NOT NULL DEFAULT 0,
  `exp_multiplier` DOUBLE NOT NULL DEFAULT 1.0,
  `drop_multiplier` DOUBLE NOT NULL DEFAULT 1.0,
  `slotbar` BLOB,
  `created_at` TIMESTAMP NULL,
  `additional_exp_multiplier` DOUBLE NOT NULL DEFAULT 0.0,
  `additional_drop_multiplier` DOUBLE NOT NULL DEFAULT 0.0,
  `aid_mode` BOOLEAN DEFAULT FALSE,
  `aid_time` INT UNSIGNED NOT NULL DEFAULT 0,
  `rank` BIGINT NOT NULL DEFAULT 0,
  `headstyle` BIGINT NOT NULL DEFAULT 0,
  `facestyle` BIGINT NOT NULL DEFAULT 0,
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  KEY `idx_user_id` (`user_id`),
  KEY `idx_name` (`name`),
  KEY `idx_type` (`type`),
  KEY `idx_map` (`map`),
  KEY `idx_level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: stats
-- Stores character stats and attributes
-- =====================================================
CREATE TABLE IF NOT EXISTS `stats` (
  `id` INT PRIMARY KEY,
  `hp` INT NOT NULL DEFAULT 0,
  `max_hp` INT NOT NULL DEFAULT 100,
  `hp_recovery_rate` INT NOT NULL DEFAULT 10,
  `chi` INT NOT NULL DEFAULT 0,
  `max_chi` INT NOT NULL DEFAULT 100,
  `chi_recovery_rate` INT NOT NULL DEFAULT 10,
  `str` INT NOT NULL DEFAULT 0,
  `dex` INT NOT NULL DEFAULT 0,
  `int` INT NOT NULL DEFAULT 0,
  `str_buff` INT NOT NULL DEFAULT 0,
  `dex_buff` INT NOT NULL DEFAULT 0,
  `int_buff` INT NOT NULL DEFAULT 0,
  `stat_points` INT NOT NULL DEFAULT 0,
  `honor` INT NOT NULL DEFAULT 0,
  `min_atk` INT NOT NULL DEFAULT 0,
  `max_atk` INT NOT NULL DEFAULT 0,
  `atk_rate` INT NOT NULL DEFAULT 0,
  `min_arts_atk` INT NOT NULL DEFAULT 0,
  `max_arts_atk` INT NOT NULL DEFAULT 0,
  `arts_atk_rate` INT NOT NULL DEFAULT 0,
  `def` INT NOT NULL DEFAULT 0,
  `def_rate` INT NOT NULL DEFAULT 0,
  `arts_def` INT NOT NULL DEFAULT 0,
  `arts_def_rate` INT NOT NULL DEFAULT 0,
  `accuracy` INT NOT NULL DEFAULT 0,
  `dodge` INT NOT NULL DEFAULT 0,
  `poison_atk` INT NOT NULL DEFAULT 0,
  `paralysis_atk` INT NOT NULL DEFAULT 0,
  `confusion_atk` INT NOT NULL DEFAULT 0,
  `poison_def` INT NOT NULL DEFAULT 0,
  `paralysis_def` INT NOT NULL DEFAULT 0,
  `confusion_def` INT NOT NULL DEFAULT 0,
  `wind` INT NOT NULL DEFAULT 0,
  `wind_buff` INT NOT NULL DEFAULT 0,
  `water` INT NOT NULL DEFAULT 0,
  `water_buff` INT NOT NULL DEFAULT 0,
  `fire` INT NOT NULL DEFAULT 0,
  `fire_buff` INT NOT NULL DEFAULT 0,
  `nature_points` INT NOT NULL DEFAULT 0,
  FOREIGN KEY (`id`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: skills
-- Stores character active and passive skills
-- =====================================================
CREATE TABLE IF NOT EXISTS `skills` (
  `id` INT PRIMARY KEY,
  `skill_points` INT NOT NULL DEFAULT 0,
  `skills` JSON NOT NULL DEFAULT '{"slots": [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}]}',
  FOREIGN KEY (`id`) REFERENCES `characters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: items_characters (Inventory)
-- Stores inventory slots with items, upgrades, sockets
-- =====================================================
CREATE TABLE IF NOT EXISTS `items_characters` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `user_id` VARCHAR(36),
  `character_id` INT NOT NULL,
  `item_id` BIGINT NOT NULL,
  `slot_id` SMALLINT NOT NULL,
  `quantity` INT UNSIGNED NOT NULL DEFAULT 1,
  `plus` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `upgrades` VARCHAR(100) DEFAULT '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}',
  `socket_count` TINYINT NOT NULL DEFAULT 0,
  `sockets` VARCHAR(100) DEFAULT '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}',
  `activated` BOOLEAN DEFAULT FALSE,
  `in_use` BOOLEAN DEFAULT FALSE,
  `pet_info` JSON,
  `updated_at` TIMESTAMP NULL,
  `consignment` BOOLEAN DEFAULT FALSE,
  `appearance` BIGINT NOT NULL DEFAULT 0,
  `item_type` SMALLINT NOT NULL DEFAULT 0,
  `judgement_stat` BIGINT NOT NULL DEFAULT 0,
  FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE,
  KEY `idx_character_id` (`character_id`),
  KEY `idx_slot_id` (`slot_id`),
  KEY `idx_item_id` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: characters_buffs
-- Stores active buffs/debuffs for characters
-- =====================================================
CREATE TABLE IF NOT EXISTS `characters_buffs` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `character_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `atk` INT NOT NULL DEFAULT 0,
  `atk_rate` INT NOT NULL DEFAULT 0,
  `arts_atk` INT NOT NULL DEFAULT 0,
  `arts_atk_rate` INT NOT NULL DEFAULT 0,
  `poison_def` INT NOT NULL DEFAULT 0,
  `paralysis_def` INT NOT NULL DEFAULT 0,
  `confusion_def` INT NOT NULL DEFAULT 0,
  `def` INT NOT NULL DEFAULT 0,
  `def_rate` INT NOT NULL DEFAULT 0,
  `arts_def` INT NOT NULL DEFAULT 0,
  `arts_def_rate` INT NOT NULL DEFAULT 0,
  `accuracy` INT NOT NULL DEFAULT 0,
  `dodge` INT NOT NULL DEFAULT 0,
  `max_hp` INT NOT NULL DEFAULT 0,
  `hp_recovery_rate` INT NOT NULL DEFAULT 0,
  `max_chi` INT NOT NULL DEFAULT 0,
  `chi_recovery_rate` INT NOT NULL DEFAULT 0,
  `str` INT NOT NULL DEFAULT 0,
  `dex` INT NOT NULL DEFAULT 0,
  `int` INT NOT NULL DEFAULT 0,
  `exp_multiplier` INT NOT NULL DEFAULT 0,
  `drop_multiplier` INT NOT NULL DEFAULT 0,
  `running_speed` DOUBLE NOT NULL DEFAULT 0,
  `started_at` BIGINT NOT NULL,
  `duration` BIGINT NOT NULL,
  `bag_expansion` BOOLEAN DEFAULT FALSE,
  `canexpire` BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (`character_id`) REFERENCES `characters` (`id`) ON DELETE CASCADE,
  KEY `idx_character_id` (`character_id`),
  KEY `idx_expiry` (`started_at`, `duration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: ai_buffs
-- Stores active buffs/debuffs for AI/Mobs
-- =====================================================
CREATE TABLE IF NOT EXISTS `ai_buffs` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `ai_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `atk` INT NOT NULL DEFAULT 0,
  `atk_rate` INT NOT NULL DEFAULT 0,
  `arts_atk` INT NOT NULL DEFAULT 0,
  `arts_atk_rate` INT NOT NULL DEFAULT 0,
  `poison_def` INT NOT NULL DEFAULT 0,
  `paralysis_def` INT NOT NULL DEFAULT 0,
  `confusion_def` INT NOT NULL DEFAULT 0,
  `def` INT NOT NULL DEFAULT 0,
  `def_rate` INT NOT NULL DEFAULT 0,
  `arts_def` INT NOT NULL DEFAULT 0,
  `arts_def_rate` INT NOT NULL DEFAULT 0,
  `accuracy` INT NOT NULL DEFAULT 0,
  `dodge` INT NOT NULL DEFAULT 0,
  `max_hp` INT NOT NULL DEFAULT 0,
  `hp_recovery_rate` INT NOT NULL DEFAULT 0,
  `max_chi` INT NOT NULL DEFAULT 0,
  `chi_recovery_rate` INT NOT NULL DEFAULT 0,
  `str` INT NOT NULL DEFAULT 0,
  `dex` INT NOT NULL DEFAULT 0,
  `int` INT NOT NULL DEFAULT 0,
  `character_id` INT NOT NULL DEFAULT 0,
  `drop_multiplier` INT NOT NULL DEFAULT 0,
  `running_speed` DOUBLE NOT NULL DEFAULT 0,
  `started_at` BIGINT NOT NULL,
  `duration` BIGINT NOT NULL,
  `skill_plus` INT NOT NULL DEFAULT 0,
  KEY `idx_ai_id` (`ai_id`),
  KEY `idx_character_id` (`character_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: guilds
-- Stores guild information, members, and resources
-- =====================================================
CREATE TABLE IF NOT EXISTS `guilds` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `leader_id` INT NOT NULL,
  `name` VARCHAR(50) UNIQUE NOT NULL,
  `member_count` SMALLINT NOT NULL DEFAULT 0,
  `members` JSON,
  `logo` LONGBLOB,
  `description` VARCHAR(500),
  `announcement` VARCHAR(500),
  `faction` SMALLINT NOT NULL DEFAULT 0,
  `gold_donation` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `honor_donation` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `recognition` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  KEY `idx_leader_id` (`leader_id`),
  KEY `idx_name` (`name`),
  KEY `idx_faction` (`faction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: ai
-- Stores AI/Mob instances spawned in the game world
-- =====================================================
CREATE TABLE IF NOT EXISTS `ai` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `pos_id` INT NOT NULL,
  `server` INT NOT NULL DEFAULT 0,
  `faction` INT NOT NULL DEFAULT 0,
  `map` SMALLINT NOT NULL,
  `coordinate` VARCHAR(50),
  `walking_speed` DOUBLE NOT NULL DEFAULT 1.0,
  `running_speed` DOUBLE NOT NULL DEFAULT 2.0,
  KEY `idx_map` (`map`),
  KEY `idx_pos_id` (`pos_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: consignment
-- Stores items on consignment board (player marketplace)
-- =====================================================
CREATE TABLE IF NOT EXISTS `consignment` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `seller_id` INT NOT NULL,
  `item_name` VARCHAR(100) NOT NULL,
  `quantity` INT NOT NULL,
  `price` BIGINT UNSIGNED NOT NULL,
  `is_sold` BOOLEAN DEFAULT FALSE,
  `expires_at` TIMESTAMP NULL DEFAULT (DATE_ADD(NOW(), INTERVAL 3 DAY)),
  KEY `idx_seller_id` (`seller_id`),
  KEY `idx_is_sold` (`is_sold`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: relics
-- Stores relic/quest item information
-- =====================================================
CREATE TABLE IF NOT EXISTS `relics` (
  `id` INT PRIMARY KEY,
  `count` INT NOT NULL DEFAULT 0,
  `limit` INT NOT NULL DEFAULT 0,
  `tradable` BOOLEAN DEFAULT FALSE,
  `required_items` VARCHAR(500)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: servers
-- Stores game server information
-- =====================================================
CREATE TABLE IF NOT EXISTS `servers` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `max_users` INT NOT NULL DEFAULT 100,
  `ispvpserver` BOOLEAN DEFAULT FALSE,
  `canloseexp` BOOLEAN DEFAULT FALSE,
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- REFERENCE/STATIC DATA TABLES
-- =====================================================

-- =====================================================
-- TABLE: items
-- Stores all available items and their properties
-- =====================================================
CREATE TABLE IF NOT EXISTS `items` (
  `id` BIGINT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `uif` VARCHAR(50),
  `type` SMALLINT NOT NULL,
  `ht_type` SMALLINT NOT NULL DEFAULT 0,
  `timer_type` SMALLINT NOT NULL DEFAULT 0,
  `timer` INT NOT NULL DEFAULT 0,
  `buy_price` BIGINT NOT NULL DEFAULT 0,
  `sell_price` BIGINT NOT NULL DEFAULT 0,
  `slot` INT NOT NULL DEFAULT 0,
  `min_level` INT NOT NULL DEFAULT 0,
  `max_level` INT NOT NULL DEFAULT 300,
  `base_def1` INT NOT NULL DEFAULT 0,
  `base_def2` INT NOT NULL DEFAULT 0,
  `base_def3` INT NOT NULL DEFAULT 0,
  `base_min_atk` INT NOT NULL DEFAULT 0,
  `base_max_atk` INT NOT NULL DEFAULT 0,
  `str` INT NOT NULL DEFAULT 0,
  `dex` INT NOT NULL DEFAULT 0,
  `int` INT NOT NULL DEFAULT 0,
  `wind` INT NOT NULL DEFAULT 0,
  `water` INT NOT NULL DEFAULT 0,
  `fire` INT NOT NULL DEFAULT 0,
  `max_hp` INT NOT NULL DEFAULT 0,
  `max_chi` INT NOT NULL DEFAULT 0,
  `min_atk` INT NOT NULL DEFAULT 0,
  `max_atk` INT NOT NULL DEFAULT 0,
  `atk_rate` INT NOT NULL DEFAULT 0,
  `min_arts_atk` INT NOT NULL DEFAULT 0,
  `max_arts_atk` INT NOT NULL DEFAULT 0,
  `arts_atk_rate` INT NOT NULL DEFAULT 0,
  `def` INT NOT NULL DEFAULT 0,
  `def_rate` INT NOT NULL DEFAULT 0,
  `arts_def` INT NOT NULL DEFAULT 0,
  `arts_def_rate` INT NOT NULL DEFAULT 0,
  `accuracy` INT NOT NULL DEFAULT 0,
  `dodge` INT NOT NULL DEFAULT 0,
  `hp_recovery` INT NOT NULL DEFAULT 0,
  `chi_recovery` INT NOT NULL DEFAULT 0,
  `holy_water_upg1` INT NOT NULL DEFAULT 0,
  `holy_water_upg2` INT NOT NULL DEFAULT 0,
  `holy_water_upg3` INT NOT NULL DEFAULT 0,
  `holy_water_rate1` INT NOT NULL DEFAULT 0,
  `holy_water_rate2` INT NOT NULL DEFAULT 0,
  `holy_water_rate3` INT NOT NULL DEFAULT 0,
  `character_type` INT NOT NULL DEFAULT 0,
  `exp_rate` DOUBLE NOT NULL DEFAULT 1.0,
  `drop_rate` DOUBLE NOT NULL DEFAULT 1.0,
  `tradable` BOOLEAN DEFAULT TRUE,
  `min_upgrade_level` SMALLINT NOT NULL DEFAULT 0,
  `npc_id` INT NOT NULL DEFAULT 0,
  `special_item` BIGINT NOT NULL DEFAULT 0,
  `running_speed` DOUBLE NOT NULL DEFAULT 0,
  `item_buff` INT NOT NULL DEFAULT 0,
  `poison_atk` INT NOT NULL DEFAULT 0,
  `poison_def` INT NOT NULL DEFAULT 0,
  `confusion_atk` INT NOT NULL DEFAULT 0,
  `confusion_def` INT NOT NULL DEFAULT 0,
  `paralysis_atk` INT NOT NULL DEFAULT 0,
  `paralysis_def` INT NOT NULL DEFAULT 0,
  KEY `idx_type` (`type`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: npc_table
-- Stores NPC/Mob template data
-- =====================================================
CREATE TABLE IF NOT EXISTS `npc_table` (
  `id` INT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `level` SMALLINT NOT NULL,
  `exp` BIGINT NOT NULL,
  `divine_exp` BIGINT NOT NULL DEFAULT 0,
  `darkness_exp` BIGINT NOT NULL DEFAULT 0,
  `gold_drop` INT NOT NULL DEFAULT 0,
  `def` INT NOT NULL DEFAULT 0,
  `max_hp` INT NOT NULL DEFAULT 100,
  `min_atk` INT NOT NULL DEFAULT 0,
  `max_atk` INT NOT NULL DEFAULT 0,
  `min_arts_atk` INT NOT NULL DEFAULT 0,
  `max_arts_atk` INT NOT NULL DEFAULT 0,
  `arts_def` INT NOT NULL DEFAULT 0,
  `drop_id` INT NOT NULL DEFAULT 0,
  `skill_id` INT NOT NULL DEFAULT 0,
  KEY `idx_name` (`name`),
  KEY `idx_level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: npc_pos_table
-- Stores NPC/AI spawn point information
-- =====================================================
CREATE TABLE IF NOT EXISTS `npc_pos_table` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `npc_id` INT NOT NULL,
  `map` SMALLINT NOT NULL,
  `rotation` DOUBLE NOT NULL DEFAULT 0,
  `min_location` VARCHAR(50),
  `max_location` VARCHAR(50),
  `count` SMALLINT NOT NULL DEFAULT 1,
  `respawn_time` INT NOT NULL DEFAULT 60,
  `is_npc` BOOLEAN DEFAULT TRUE,
  `attackable` BOOLEAN DEFAULT TRUE,
  `faction` INT NOT NULL DEFAULT 0,
  KEY `idx_npc_id` (`npc_id`),
  KEY `idx_map` (`map`),
  KEY `idx_is_npc` (`is_npc`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: skill_definitions
-- Stores skill template data
-- =====================================================
CREATE TABLE IF NOT EXISTS `skill_definitions` (
  `id` INT PRIMARY KEY,
  `book_id` BIGINT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `target` TINYINT NOT NULL DEFAULT 0,
  `passive_type` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `type` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `max_plus` TINYINT NOT NULL DEFAULT 0,
  `slot` INT NOT NULL DEFAULT 0,
  `base_duration` INT NOT NULL DEFAULT 0,
  `additional_duration` INT NOT NULL DEFAULT 0,
  `cast_time` DOUBLE NOT NULL DEFAULT 0,
  `base_chi` INT NOT NULL DEFAULT 0,
  `additional_chi` INT NOT NULL DEFAULT 0,
  `base_min_multiplier` INT NOT NULL DEFAULT 0,
  `additional_min_multiplier` INT NOT NULL DEFAULT 0,
  `base_max_multiplier` INT NOT NULL DEFAULT 0,
  `additional_max_multiplier` INT NOT NULL DEFAULT 0,
  `base_radius` DOUBLE NOT NULL DEFAULT 0,
  `additional_radius` DOUBLE NOT NULL DEFAULT 0,
  `passive` BOOLEAN DEFAULT FALSE,
  `base_passive` INT NOT NULL DEFAULT 0,
  `additional_passive` INT NOT NULL DEFAULT 0,
  `infection_id` INT NOT NULL DEFAULT 0,
  `area_center` INT NOT NULL DEFAULT 0,
  `cooldown` DOUBLE NOT NULL DEFAULT 0,
  KEY `idx_book_id` (`book_id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: buff_infections
-- Stores buff/debuff properties for infections
-- =====================================================
CREATE TABLE IF NOT EXISTS `buff_infections` (
  `id` INT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `poison_def` INT NOT NULL DEFAULT 0,
  `additional_poison_def` INT NOT NULL DEFAULT 0,
  `paralysis_def` INT NOT NULL DEFAULT 0,
  `additional_para_def` INT NOT NULL DEFAULT 0,
  `confusion_def` INT NOT NULL DEFAULT 0,
  `additional_confusion_def` INT NOT NULL DEFAULT 0,
  `base_def` INT NOT NULL DEFAULT 0,
  `additional_def` INT NOT NULL DEFAULT 0,
  `arts_def` INT NOT NULL DEFAULT 0,
  `additional_arts_def` INT NOT NULL DEFAULT 0,
  `max_hp` INT NOT NULL DEFAULT 0,
  `hp_recovery_rate` INT NOT NULL DEFAULT 0,
  `str` INT NOT NULL DEFAULT 0,
  `additional_str` INT NOT NULL DEFAULT 0,
  `dex` INT NOT NULL DEFAULT 0,
  `additional_dex` INT NOT NULL DEFAULT 0,
  `int` INT NOT NULL DEFAULT 0,
  `additional_int` INT NOT NULL DEFAULT 0,
  `wind` INT NOT NULL DEFAULT 0,
  `additional_wind` INT NOT NULL DEFAULT 0,
  `water` INT NOT NULL DEFAULT 0,
  `additional_water` INT NOT NULL DEFAULT 0,
  `fire` INT NOT NULL DEFAULT 0,
  `additional_fire` INT NOT NULL DEFAULT 0,
  `additional_hp` INT NOT NULL DEFAULT 0,
  `base_atk` INT NOT NULL DEFAULT 0,
  `additional_atk` INT NOT NULL DEFAULT 0,
  `base_arts_atk` INT NOT NULL DEFAULT 0,
  `additional_arts_atk` INT NOT NULL DEFAULT 0,
  `accuracy` INT NOT NULL DEFAULT 0,
  `additional_accuracy` INT NOT NULL DEFAULT 0,
  `dodge_rate` INT NOT NULL DEFAULT 0,
  `additional_dodge_rate` INT NOT NULL DEFAULT 0,
  `movement_speed` DOUBLE NOT NULL DEFAULT 0,
  `additional_movement_speed` DOUBLE NOT NULL DEFAULT 0,
  `exp_rate` INT NOT NULL DEFAULT 0,
  `hyeolgong_cost` INT NOT NULL DEFAULT 0,
  `npc_selling` INT NOT NULL DEFAULT 0,
  `npc_buying` INT NOT NULL DEFAULT 0,
  `ispercent` BOOLEAN DEFAULT FALSE,
  `lightning_radius` INT NOT NULL DEFAULT 0,
  `attack_speed` INT NOT NULL DEFAULT 0,
  `additional_hp_recovery` INT NOT NULL DEFAULT 0,
  `max_chi` INT NOT NULL DEFAULT 0,
  `damage_reflection` INT NOT NULL DEFAULT 0,
  `drop_item` INT NOT NULL DEFAULT 0,
  `enchanced_prob` INT NOT NULL DEFAULT 0,
  `synthetic_composite` INT NOT NULL DEFAULT 0,
  `advanced_composite` INT NOT NULL DEFAULT 0,
  `pet_base_hp` INT NOT NULL DEFAULT 0,
  `pet_additional_hp` INT NOT NULL DEFAULT 0,
  `pet_base_def` INT NOT NULL DEFAULT 0,
  `pet_additional_def` INT NOT NULL DEFAULT 0,
  `pet_base_arts_def` INT NOT NULL DEFAULT 0,
  `pet_additional_arts_def` INT NOT NULL DEFAULT 0,
  `additional_attack_speed` INT NOT NULL DEFAULT 0,
  `makesize` DOUBLE NOT NULL DEFAULT 0,
  `critical_strike` INT NOT NULL DEFAULT 0,
  `additional_critical_strike` INT NOT NULL DEFAULT 0,
  `cash_acquired` INT NOT NULL DEFAULT 0,
  `taking_effect_probability` INT NOT NULL DEFAULT 0,
  `additional_taking_effect_probability` INT NOT NULL DEFAULT 0,
  `additional_damage_reflection` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: buff_icons
-- Maps skills to buff icons
-- =====================================================
CREATE TABLE IF NOT EXISTS `buff_icons` (
  `skill_id` INT PRIMARY KEY,
  `icon_id` INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: job_passives
-- Stores base stats for each job class
-- =====================================================
CREATE TABLE IF NOT EXISTS `job_passives` (
  `id` TINYINT PRIMARY KEY,
  `max_hp` INT NOT NULL DEFAULT 0,
  `max_chi` INT NOT NULL DEFAULT 0,
  `atk` INT NOT NULL DEFAULT 0,
  `arts_atk` INT NOT NULL DEFAULT 0,
  `def` INT NOT NULL DEFAULT 0,
  `arts_def` INT NOT NULL DEFAULT 0,
  `accuracy` INT NOT NULL DEFAULT 0,
  `dodge` INT NOT NULL DEFAULT 0,
  `confusion_def` INT NOT NULL DEFAULT 0,
  `poison_def` INT NOT NULL DEFAULT 0,
  `paralysis_def` INT NOT NULL DEFAULT 0,
  `hp_recovery_rate` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: exp_table
-- Stores experience requirements and point gains
-- =====================================================
CREATE TABLE IF NOT EXISTS `exp_table` (
  `level` SMALLINT PRIMARY KEY,
  `exp` BIGINT NOT NULL,
  `skill_points` INT NOT NULL DEFAULT 0,
  `stat_points` INT NOT NULL DEFAULT 0,
  `nature_points` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: pets (Data)
-- Stores pet template information
-- =====================================================
CREATE TABLE IF NOT EXISTS `pets` (
  `id` BIGINT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `evolution` SMALLINT NOT NULL DEFAULT 0,
  `level` SMALLINT NOT NULL DEFAULT 1,
  `target_level` SMALLINT NOT NULL DEFAULT 1,
  `evolved_id` BIGINT NOT NULL DEFAULT 0,
  `base_str` INT NOT NULL DEFAULT 0,
  `additional_str` INT NOT NULL DEFAULT 0,
  `base_dex` INT NOT NULL DEFAULT 0,
  `additional_dex` INT NOT NULL DEFAULT 0,
  `base_int` INT NOT NULL DEFAULT 0,
  `additional_int` INT NOT NULL DEFAULT 0,
  `base_hp` INT NOT NULL DEFAULT 0,
  `additional_hp` INT NOT NULL DEFAULT 0,
  `base_chi` INT NOT NULL DEFAULT 0,
  `additional_chi` INT NOT NULL DEFAULT 0,
  `skill_id` INT NOT NULL DEFAULT 0,
  `combat` BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: productions
-- Stores crafting/production recipes
-- =====================================================
CREATE TABLE IF NOT EXISTS `productions` (
  `id` INT PRIMARY KEY,
  `materials` JSON NOT NULL,
  `probability` INT NOT NULL DEFAULT 0,
  `cost` BIGINT NOT NULL DEFAULT 0,
  `production` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: advanced_fusion
-- Stores item fusion recipes
-- =====================================================
CREATE TABLE IF NOT EXISTS `advanced_fusion` (
  `item1` BIGINT PRIMARY KEY,
  `item2` BIGINT NOT NULL,
  `count2` SMALLINT NOT NULL DEFAULT 1,
  `item3` BIGINT NOT NULL DEFAULT 0,
  `count3` SMALLINT NOT NULL DEFAULT 0,
  `special_item` BIGINT NOT NULL DEFAULT 0,
  `special_item_count` SMALLINT NOT NULL DEFAULT 0,
  `probability` INT NOT NULL DEFAULT 0,
  `cost` BIGINT NOT NULL DEFAULT 0,
  `production` BIGINT NOT NULL DEFAULT 0,
  `destroy_on_fail` BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: drops
-- Stores drop table information
-- =====================================================
CREATE TABLE IF NOT EXISTS `drops` (
  `id` INT PRIMARY KEY,
  `items` VARCHAR(500) NOT NULL DEFAULT '{}',
  `probabilities` VARCHAR(500) NOT NULL DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: item_set
-- Stores item set bonuses
-- =====================================================
CREATE TABLE IF NOT EXISTS `item_set` (
  `id` INT PRIMARY KEY,
  `itemcount` INT NOT NULL DEFAULT 0,
  `itemsid` VARCHAR(500) NOT NULL DEFAULT '{}',
  `bonusid` VARCHAR(500) NOT NULL DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: gates
-- Stores map gate/portal information
-- =====================================================
CREATE TABLE IF NOT EXISTS `gates` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `target_map` TINYINT UNSIGNED NOT NULL,
  `point` VARCHAR(50) NOT NULL DEFAULT '(0,0)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: save_points
-- Stores respawn/save point locations
-- =====================================================
CREATE TABLE IF NOT EXISTS `save_points` (
  `id` TINYINT UNSIGNED PRIMARY KEY,
  `point` VARCHAR(50) NOT NULL DEFAULT '(0,0)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: shop_table
-- Stores NPC shop definitions
-- =====================================================
CREATE TABLE IF NOT EXISTS `shop_table` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `types` VARCHAR(500) NOT NULL DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: shop_items
-- Stores shop type to items mapping
-- =====================================================
CREATE TABLE IF NOT EXISTS `shop_items` (
  `type` INT PRIMARY KEY,
  `items` VARCHAR(500) NOT NULL DEFAULT '{}'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: fiveclan_war
-- Stores 5-clan war area capture information
-- =====================================================
CREATE TABLE IF NOT EXISTS `fiveclan_war` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `clanid` INT NOT NULL,
  `expires_at` TIMESTAMP NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: relic_log
-- Stores relic drop history
-- =====================================================
CREATE TABLE IF NOT EXISTS `relic_log` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `item_id` BIGINT NOT NULL,
  `drop_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  KEY `idx_drop_time` (`drop_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: craft_items
-- Stores crafting item templates
-- =====================================================
CREATE TABLE IF NOT EXISTS `craft_items` (
  `id` INT PRIMARY KEY,
  `materials` LONGBLOB,
  `production` VARCHAR(500) NOT NULL,
  `probabilities` VARCHAR(500) NOT NULL,
  `cost` BIGINT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: ht_shop
-- Stores HT shop items
-- =====================================================
CREATE TABLE IF NOT EXISTS `ht_shop` (
  `id` BIGINT PRIMARY KEY,
  `cash` INT NOT NULL,
  `is_active` BOOLEAN DEFAULT TRUE,
  `ht_id` INT NOT NULL DEFAULT 0,
  `is_new` BOOLEAN DEFAULT FALSE,
  `is_popular` BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: item_meltings
-- Stores item melting recipes
-- =====================================================
CREATE TABLE IF NOT EXISTS `item_meltings` (
  `id` INT PRIMARY KEY,
  `melted_items` VARCHAR(500),
  `item_counts` VARCHAR(500),
  `profit_multiplier` DOUBLE,
  `probability` INT NOT NULL DEFAULT 0,
  `cost` BIGINT NOT NULL DEFAULT 0,
  `special_item` INT NOT NULL DEFAULT 0,
  `special_probability` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: npc_scripts
-- Stores NPC script data
-- =====================================================
CREATE TABLE IF NOT EXISTS `npc_scripts` (
  `id` INT PRIMARY KEY,
  `script` JSON NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: pet_exp_table
-- Stores pet experience requirements
-- =====================================================
CREATE TABLE IF NOT EXISTS `pet_exp_table` (
  `level` SMALLINT PRIMARY KEY,
  `req_exp_evo1` INT NOT NULL DEFAULT 0,
  `req_exp_evo2` INT NOT NULL DEFAULT 0,
  `req_exp_evo3` INT NOT NULL DEFAULT 0,
  `req_exp_ht` INT NOT NULL DEFAULT 0,
  `req_exp_div_evo1` INT NOT NULL DEFAULT 0,
  `req_exp_div_evo2` INT NOT NULL DEFAULT 0,
  `req_exp_div_evo3` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: stackables
-- Stores stackable item information
-- =====================================================
CREATE TABLE IF NOT EXISTS `stackables` (
  `id` INT PRIMARY KEY,
  `uif` VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: hax_codes
-- Stores HT extraction codes
-- =====================================================
CREATE TABLE IF NOT EXISTS `hax_codes` (
  `id` INT PRIMARY KEY,
  `code` VARCHAR(2) NOT NULL,
  `sale_multiplier` INT NOT NULL DEFAULT 0,
  `extraction_multiplier` INT NOT NULL DEFAULT 0,
  `extracted_item` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: gambling
-- Stores gambling table information
-- =====================================================
CREATE TABLE IF NOT EXISTS `gambling` (
  `id` INT PRIMARY KEY,
  `cost` BIGINT NOT NULL DEFAULT 0,
  `drop_id` INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: reborn_system
-- Stores reborn stat bonuses
-- =====================================================
CREATE TABLE IF NOT EXISTS `reborn_system` (
  `id` INT PRIMARY KEY,
  `honor_id` INT NOT NULL,
  `str` INT NOT NULL DEFAULT 0,
  `dex` INT NOT NULL DEFAULT 0,
  `int` INT NOT NULL DEFAULT 0,
  `plus_stat` INT NOT NULL DEFAULT 0,
  `plus_skillpoint` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLE: item_judgement
-- Stores item judgement bonuses
-- =====================================================
CREATE TABLE IF NOT EXISTS `item_judgement` (
  `id` INT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `attack_plus` INT NOT NULL DEFAULT 0,
  `accuracy_plus` INT NOT NULL DEFAULT 0,
  `str_plus` INT NOT NULL DEFAULT 0,
  `dex_plus` INT NOT NULL DEFAULT 0,
  `int_plus` INT NOT NULL DEFAULT 0,
  `extra_def` INT NOT NULL DEFAULT 0,
  `Max_HP` INT NOT NULL DEFAULT 0,
  `Max_CHI` INT NOT NULL DEFAULT 0,
  `extra_arts_def` INT NOT NULL DEFAULT 0,
  `extra_dodge` INT NOT NULL DEFAULT 0,
  `extra_attackspeed` INT NOT NULL DEFAULT 0,
  `wind_plus` INT NOT NULL DEFAULT 0,
  `water_plus` INT NOT NULL DEFAULT 0,
  `fire_plus` INT NOT NULL DEFAULT 0,
  `extra_arts_range` DOUBLE NOT NULL DEFAULT 0,
  `ismeretlen` INT NOT NULL DEFAULT 0,
  `probabilities` BIGINT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- Insert default admin user
-- ============================================================
INSERT INTO `users` (`id`, `user_name`, `password`, `user_type`, `ip`, `ncash`, `bank_gold`, `mail`, `created_at`) 
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'herorebirth', '2692c242a3c13e514038b8370fc62eaf271dbb42c649f95222d5cc049f6240b0', 5, '127.0.0.1', 99999999, 99999999, 'herorebirth@herorebirth.dev', NOW());