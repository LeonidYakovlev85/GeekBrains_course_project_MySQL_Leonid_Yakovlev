DROP FUNCTION IF EXISTS `purchases_db`.`first_status_id`;
DELIMITER //
CREATE FUNCTION `purchases_db`.`first_status_id`(`purchases_id_arg` INT)
RETURNS NUMERIC DETERMINISTIC
BEGIN
	DECLARE `first_status_id_var` INT;
    SELECT MIN(`id`) INTO `first_status_id_var`
		FROM `purchases_db`.`purchase_status` AS `status`
		WHERE `status`.`purchases_id` = `purchases_id_arg`;
    RETURN `first_status_id_var`;
END//
DELIMITER ;