DROP SCHEMA IF EXISTS `purchases_db` ;
CREATE SCHEMA IF NOT EXISTS `purchases_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `purchases_db` ;

DROP TABLE IF EXISTS `purchases_db`.`departments` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`departments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `department_name_full` VARCHAR(254) NOT NULL COMMENT 'Полное наименование отдела',
  `department_name_short` VARCHAR(45) NOT NULL COMMENT 'Сокращённое наименование отдела ',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `department_name_short_UNIQUE` (`department_name_short` ASC),
  UNIQUE INDEX `department_name_full_UNIQUE` (`department_name_full` ASC))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`products_types` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`products_types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_type` VARCHAR(45) NOT NULL COMMENT 'Тип продукции -- товары / услуги / etc.',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `product_type_UNIQUE` (`product_type` ASC))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`purchases_types` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`purchases_types` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `purchase_type` VARCHAR(45) NOT NULL COMMENT 'Тип закупки -- конкурентная / неконкурентная / etc.',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `purchase_type_UNIQUE` (`purchase_type` ASC))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`procurement_plan` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`procurement_plan` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `reporting_year` YEAR(4) NOT NULL COMMENT 'Календарный год, для которого составляется план',
  `number_within_year` INT UNSIGNED NOT NULL COMMENT 'Номер закупки внутри годового плана',
  `purchase_name` VARCHAR(510) NOT NULL COMMENT 'Полное официальное наименование закупки',
  `departments_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор отдела, для которого выполняется закупка',
  `product_types_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор типа продукции',
  `purchase_types_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор типа закупки',
  `planned_cost_thou_of_rub` INT UNSIGNED NOT NULL COMMENT 'Стоимость в тыс. руб., предусмотренная бюджетом',
  `date_start` DATE NOT NULL COMMENT 'Предполагаемая дата начала закупки',
  `date_finish` DATE NOT NULL COMMENT 'Предполагаемая дата окончания закупки',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `number_within_year` (`reporting_year` ASC, `number_within_year` ASC),
  INDEX `fk_procurement_plan_departments_idx` (`departments_id` ASC),
  INDEX `fk_procurement_plan_products_types1_idx` (`product_types_id` ASC),
  INDEX `fk_procurement_plan_purchases_types1_idx` (`purchase_types_id` ASC),
  CONSTRAINT `fk_procurement_plan_departments`
    FOREIGN KEY (`departments_id`)
    REFERENCES `purchases_db`.`departments` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_procurement_plan_products_types1`
    FOREIGN KEY (`product_types_id`)
    REFERENCES `purchases_db`.`products_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_procurement_plan_purchases_types1`
    FOREIGN KEY (`purchase_types_id`)
    REFERENCES `purchases_db`.`purchases_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`other_procurement_register` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`other_procurement_register` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `reporting_year` YEAR(4) NOT NULL COMMENT 'Календарный год, для которого составлен реестр',
  `number_within_year` INT UNSIGNED NOT NULL COMMENT 'Номер закупки внутри реестра по году',
  `purchase_name` VARCHAR(510) NOT NULL COMMENT 'Полное официальное наименование закупки',
  `departments_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор отдела, для которого выполняется закупка',
  `product_types_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор типа продукции',
  `purchase_types_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор типа закупки',
  `planned_cost_thou_of_rub` INT UNSIGNED NOT NULL COMMENT 'Стоимость в тыс. руб., предусмотренная бюджетом',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `number_within_year` (`reporting_year` ASC, `number_within_year` ASC),
  INDEX `fk_other_procurement_register_products_types1_idx` (`product_types_id` ASC),
  INDEX `fk_other_procurement_register_departments1_idx` (`departments_id` ASC),
  INDEX `fk_other_procurement_register_purchases_types1_idx` (`purchase_types_id` ASC),
  CONSTRAINT `fk_other_procurement_register_departments1`
    FOREIGN KEY (`departments_id`)
    REFERENCES `purchases_db`.`departments` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_other_procurement_register_products_types1`
    FOREIGN KEY (`product_types_id`)
    REFERENCES `purchases_db`.`products_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_other_procurement_register_purchases_types1`
    FOREIGN KEY (`purchase_types_id`)
    REFERENCES `purchases_db`.`purchases_types` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`purchases` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`purchases` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Номер закупки в сквозной нумерации.',
  `procurement_plan_id` INT UNSIGNED COMMENT 'Номер закупки по годовому плану',
  `other_procurement_register_id` INT UNSIGNED COMMENT 'Номер закупки по другому реестру',
  `comment` TEXT NULL COMMENT 'Комментарий к закупке',
  PRIMARY KEY (`id`),
  INDEX `fk_purchases_procurement_plan1_idx` (`procurement_plan_id` ASC),
  INDEX `fk_purchases_other_procurement_register1_idx` (`other_procurement_register_id` ASC),
  INDEX `fk_purchases_procurement_register_num1` (`procurement_plan_id` ASC, `other_procurement_register_id` ASC),
  CONSTRAINT `fk_purchases_procurement_plan1`
    FOREIGN KEY (`procurement_plan_id`)
    REFERENCES `purchases_db`.`procurement_plan` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_purchases_other_procurement_register1`
    FOREIGN KEY (`other_procurement_register_id`)
    REFERENCES `purchases_db`.`other_procurement_register` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`events` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`events` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `event_name` VARCHAR(510) NOT NULL COMMENT 'Наименование события',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`stages` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`stages` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `stage_name` VARCHAR(254) NOT NULL COMMENT 'Наименование текущего этапа',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`responsible` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`responsible` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `last_name` VARCHAR(45) NOT NULL COMMENT 'Фамилия исполнителя',
  `first_name` VARCHAR(45) NOT NULL COMMENT 'Имя исполнителя',
  `middle_name` VARCHAR(45) NOT NULL COMMENT 'Отчество исполнителя',
  `position` VARCHAR(126) NOT NULL COMMENT 'Должность исполнителя',
  `initials` VARCHAR(45) AS (CONCAT(`last_name`, ' ', LEFT(`first_name`, 1), '. ', LEFT(`middle_name`, 1), '. ')) STORED COMMENT 'Автостолбец Фамилия и инициалы исполнителя',
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`purchase_status` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`purchase_status` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `purchases_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор закупки в сводной таблице Purchase',
  `events_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор события',
  `date` DATE NOT NULL COMMENT 'Дата события',
  `stages_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор текущего этапа',
  `approximate_date` DATE NOT NULL,
  `responsible_id` INT UNSIGNED NOT NULL COMMENT 'Планируемая дата завершения текущего этапа',
  PRIMARY KEY (`id`),
  INDEX `fk_purchase_status_purchases1_idx` (`purchases_id` ASC),
  INDEX `fk_purchase_status_events1_idx` (`events_id` ASC),
  INDEX `fk_purchase_status_stages1_idx` (`stages_id` ASC),
  INDEX `fk_purchase_status_responsible1_idx` (`responsible_id` ASC),
  CONSTRAINT `fk_purchase_status_purchases1`
    FOREIGN KEY (`purchases_id`)
    REFERENCES `purchases_db`.`purchases` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_purchase_status_events1`
    FOREIGN KEY (`events_id`)
    REFERENCES `purchases_db`.`events` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_purchase_status_stages1`
    FOREIGN KEY (`stages_id`)
    REFERENCES `purchases_db`.`stages` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_purchase_status_responsible1`
    FOREIGN KEY (`responsible_id`)
    REFERENCES `purchases_db`.`responsible` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`procurement_documents_register` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`procurement_documents_register` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `purchase_status_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор записи в таблице purchase_status',
  `protocol_number` INT UNSIGNED NOT NULL COMMENT 'Номер протокола заседания закупочной комиссии',
  `protocol_url` VARCHAR(254) NOT NULL COMMENT 'Ссылка на файл протокола заседания закупочной комиссии',
  `comparison_table_url` VARCHAR(254) NULL COMMENT 'Ссылка на файл сопоставительной таблицы',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `comparison_table_url_UNIQUE` (`comparison_table_url` ASC),
  INDEX `fk_procurement_documents_register_purchase_status1_idx` (`purchase_status_id` ASC),
  CONSTRAINT `fk_procurement_documents_register_purchase_status1`
    FOREIGN KEY (`purchase_status_id`)
    REFERENCES `purchases_db`.`purchase_status` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `purchases_db`.`winners` ;
CREATE TABLE IF NOT EXISTS `purchases_db`.`winners` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `purchases_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор закупки в сводной таблице Purchase',
  `winner_name` VARCHAR(1022) NOT NULL COMMENT 'Наименование победителя (или победителей)',
  `initial_cost_thou_of_rub` INT UNSIGNED NOT NULL COMMENT 'Начальная цена предложения в тысячах рублей',
  `total_cost_thou_of_rub` INT UNSIGNED NOT NULL COMMENT 'Итоговая цена предложения в тысячах рублей',
  PRIMARY KEY (`id`),
  INDEX `fk_winners_purchases1_idx` (`purchases_id` ASC),
  CONSTRAINT `fk_winners_purchases1`
    FOREIGN KEY (`purchases_id`)
    REFERENCES `purchases_db`.`purchases` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;