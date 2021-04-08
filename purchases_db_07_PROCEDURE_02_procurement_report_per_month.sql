DROP PROCEDURE IF EXISTS `purchases_db`.`procurement_report_per_month`;
DELIMITER //
CREATE PROCEDURE `purchases_db`.`procurement_report_per_month` (`year_arg` INT, `month_arg` INT)
BEGIN
	SET @row_number = 0;
	SELECT
		(@row_number:=@row_number + 1) AS '№ п/п',
		`purch_f`.`id` AS 'Номер закупки',
		`purch_f`.`purchase_name` AS 'Наименование закупки',
		`purch_f`.`department_name_full` AS 'Заказывающее подразделение',
		`purch_f`.`product_type` AS 'Тип закупаемой продукции',
		`purch_f`.`purchase_type` AS 'Тип закупки',
		`purch_f`.`planned_cost_thou_of_rub` AS 'Запланированная стоимость, тыс. руб.',
		`winners`.`winner_name` AS 'Победитель',
		`winners`.`initial_cost_thou_of_rub` AS 'Начальная цена предложения, тыс. руб',
		`winners`.`total_cost_thou_of_rub` AS 'Итоговая цена предложения, тыс. руб.',
		`winners`.`initial_cost_thou_of_rub` -  `winners`.`total_cost_thou_of_rub` AS 'Экономия от начальной стоимости, тыс. руб.',
		ROUND(100 - `winners`.`total_cost_thou_of_rub` / `winners`.`initial_cost_thou_of_rub` * 100, 2) AS 'Экономия от начальной стоимости, %',
		CAST(`purch_f`.`planned_cost_thou_of_rub` AS SIGNED) - CAST(`winners`.`total_cost_thou_of_rub` AS SIGNED) AS 'Экономия от бюджета, тыс. руб.',
		ROUND(100 - `winners`.`total_cost_thou_of_rub` / `purch_f`.`planned_cost_thou_of_rub` * 100, 2) AS 'Экономия от бюджета, %'
	FROM `purchases_db`.`purchases_full` AS `purch_f`
	INNER JOIN `purchases_db`.`purchase_status` AS `status`
		ON `purch_f`.`id` = `status`.`purchases_id`
		AND YEAR(`status`.`date`) = `year_arg`
		AND MONTH(`status`.`date`) = `month_arg`
		AND `status`.`events_id` = 9
	INNER JOIN `purchases_db`.`winners` AS `winners`
		ON `purch_f`.`id` = `winners`.`purchases_id`
	ORDER BY `purch_f`.`id`;
END//
DELIMITER ;