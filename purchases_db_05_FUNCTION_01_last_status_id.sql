DROP FUNCTION IF EXISTS `purchases_db`.`last_status_id`;
DELIMITER //
CREATE FUNCTION `purchases_db`.`last_status_id`(`purchases_id_arg` INT)
RETURNS NUMERIC DETERMINISTIC
BEGIN
	DECLARE `last_status_id_var` INT;
    SELECT MAX(`id`) INTO `last_status_id_var`
		FROM `purchases_db`.`purchase_status` AS `status`
		WHERE `status`.`purchases_id` = `purchases_id_arg`;
    RETURN `last_status_id_var`;
END//
DELIMITER ;