DROP PROCEDURE IF EXISTS `purchases_db`.`current_purchases`;
DELIMITER //
CREATE PROCEDURE `purchases_db`.`current_purchases`()
BEGIN
	SELECT
		`purch_f`.`id` AS 'Номер закупки',
		`purch_f`.`purchase_name` AS 'Наименование закупки',
		`purch_f`.`department_name_short` AS 'Заказывающее подразделение',
		`status_f`.`event_name` AS 'Последнее событие',
		`status_f`.`date` AS 'Дата последнего события',
		`status_f`.`stage_name` AS 'Текущий этап',
		`status_f`.`approximate_date` AS 'Дата завершения текущего этапа',
		`status_f`.`responsible_initials` AS 'Исполнитель',
		`purch_f`.`comment` AS 'Комментарий'
	FROM `purchases_db`.`purchases_full` AS `purch_f`
	INNER JOIN `purchases_db`.`purchase_status_full` AS `status_f`
		ON `purch_f`.`id` = `status_f`.`purchases_id`
		AND `status_f`.`status_id` = `purchases_db`.`last_status_id`(`purch_f`.`id`)
		AND `status_f`.`events_id` != 9
		AND `status_f`.`events_id` != 10
	ORDER BY `purch_f`.`id`;
END//
DELIMITER ;