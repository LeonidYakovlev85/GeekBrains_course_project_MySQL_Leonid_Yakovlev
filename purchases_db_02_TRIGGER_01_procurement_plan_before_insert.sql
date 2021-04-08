DROP TRIGGER IF EXISTS `purchases_db`.`procurement_plan_before_insert`;
DELIMITER //
CREATE TRIGGER `purchases_db`.`procurement_plan_before_insert` BEFORE INSERT ON `purchases_db`.`procurement_plan`
FOR EACH ROW
BEGIN   
    IF NEW.`date_finish` <= NEW.`date_start` THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Дата завершения закупки не может быть меньше или равна дате начала';
	END IF;
END//
DELIMITER ;