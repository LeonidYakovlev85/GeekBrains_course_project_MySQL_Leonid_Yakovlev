DROP PROCEDURE IF EXISTS `purchases_db`.`procurement_report_per_year`;
DELIMITER //
CREATE PROCEDURE `purchases_db`.`procurement_report_per_year` (`year_arg` INT)
BEGIN
	SET @`row_number` = 0;
	SELECT
		(@`row_number`:=@`row_number` + 1) AS '№ п/п',
		'Всего состоявшихся закупок' AS 'Тип закупки',
		COUNT(`purch_f`.`id`) AS 'Количество закупок',
		SUM(`purch_f`.`planned_cost_thou_of_rub`) AS 'Общая стоимость по бюджету, тыс. руб.',
		SUM(`winners`.`total_cost_thou_of_rub`) AS 'Общая стоимость закупок, тыс. руб.',
		ROUND(AVG(100 - `winners`.`total_cost_thou_of_rub` / `winners`.`initial_cost_thou_of_rub` * 100), 2) AS 'Средний размер скидки, %',
		SUM(`purch_f`.`planned_cost_thou_of_rub`) - SUM(`winners`.`total_cost_thou_of_rub`) AS 'Экономия от бюджета, тыс. руб.',
		ROUND(100 - SUM(`winners`.`total_cost_thou_of_rub`) / SUM(`purch_f`.`planned_cost_thou_of_rub`) * 100, 2) AS 'Экономия от бюджета, %'
	FROM `purchases_db`.`purchases_full` AS `purch_f`
	LEFT OUTER JOIN `purchases_db`.`purchase_status` AS `status`
		ON `purch_f`.`id` = `status`.`purchases_id`
		AND `status`.`events_id` = 9
	LEFT OUTER JOIN `purchases_db`.`winners` AS `winners`
		ON `purch_f`.`id` = `winners`.`purchases_id`
	WHERE YEAR(`status`.`date`) = `year_arg`

	UNION ALL

	SELECT
		(@`row_number`:=@`row_number` + 1) AS '№ п/п',
		'Из них конкуретных' AS 'Тип закупки',
		COUNT(`purch_f`.`id`) AS 'Количество закупок',
		SUM(`purch_f`.`planned_cost_thou_of_rub`) AS 'Общая стоимость по бюджету, тыс. руб.',
		SUM(`winners`.`total_cost_thou_of_rub`) AS 'Общая стоимость закупок, тыс. руб.',
		ROUND(AVG(100 - `winners`.`total_cost_thou_of_rub` / `winners`.`initial_cost_thou_of_rub` * 100), 2) AS 'Средний размер скидки, %',
		'---' AS 'Экономия от бюджета, тыс. руб.',
		'---' AS 'Экономия от бюджета, %'
	FROM `purchases_db`.`purchases_full` AS `purch_f`
	LEFT OUTER JOIN `purchases_db`.`purchase_status` AS `status`
		ON `purch_f`.`id` = `status`.`purchases_id`
		AND `status`.`events_id` = 9
	LEFT OUTER JOIN `purchases_db`.`winners` AS `winners`
		ON `purch_f`.`id` = `winners`.`purchases_id`
	WHERE
		YEAR(`status`.`date`) = `year_arg`
		AND `purch_f`.`purchase_types_id` = 1
		
	UNION ALL
    
    	SELECT
		(@`row_number`:=@`row_number` + 1) AS '№ п/п',
		'Из них неконкуретных' AS 'Тип закупки',
		COUNT(`purch_f`.`id`) AS 'Количество закупок',
		SUM(`purch_f`.`planned_cost_thou_of_rub`) AS 'Общая стоимость по бюджету, тыс. руб.',
		SUM(`winners`.`total_cost_thou_of_rub`) AS 'Общая стоимость закупок, тыс. руб.',
		ROUND(AVG(100 - `winners`.`total_cost_thou_of_rub` / `winners`.`initial_cost_thou_of_rub` * 100), 2) AS 'Средний размер скидки, %',
		'---' AS 'Экономия от бюджета, тыс. руб.',
		'---' AS 'Экономия от бюджета, %'
	FROM `purchases_db`.`purchases_full` AS `purch_f`
	LEFT OUTER JOIN `purchases_db`.`purchase_status` AS `status`
		ON `purch_f`.`id` = `status`.`purchases_id`
		AND `status`.`events_id` = 9
	LEFT OUTER JOIN `purchases_db`.`winners` AS `winners`
		ON `purch_f`.`id` = `winners`.`purchases_id`
	WHERE
		YEAR(`status`.`date`) = `year_arg`
		AND `purch_f`.`purchase_types_id` = 2

	UNION ALL
    
    SELECT
		(@`row_number`:=@`row_number` + 1) AS '№ п/п',
		'Из них запланированных' AS 'Тип закупки',
		COUNT(`purch_f`.`id`) AS 'Количество закупок',
		SUM(`purch_f`.`planned_cost_thou_of_rub`) AS 'Общая стоимость по бюджету, тыс. руб.',
		SUM(`winners`.`total_cost_thou_of_rub`) AS 'Общая стоимость закупок, тыс. руб.',
		'---' AS 'Средний размер скидки, %',
		'---' AS 'Экономия от бюджета, тыс. руб.',
		'---' AS  'Экономия от бюджета, %'
	FROM `purchases_db`.`purchases_full` AS `purch_f`
	LEFT OUTER JOIN `purchases_db`.`purchase_status` AS `status`
		ON `purch_f`.`id` = `status`.`purchases_id`
		AND `status`.`events_id` = 9
	LEFT OUTER JOIN `purchases_db`.`winners` AS `winners`
		ON `purch_f`.`id` = `winners`.`purchases_id`
	WHERE
		YEAR(`status`.`date`) = `year_arg`
		AND `purch_f`.`procurement_plan_id` IS NOT NULL
	
    UNION ALL
    
    SELECT
		(@`row_number`:=@`row_number` + 1) AS '№ п/п',
		'Из них закупок из другого реестра' AS 'Тип закупки',
		COUNT(`purch_f`.`id`) AS 'Количество закупок',
		SUM(`purch_f`.`planned_cost_thou_of_rub`) AS 'Общая стоимость по бюджету, тыс. руб.',
		SUM(`winners`.`total_cost_thou_of_rub`) AS 'Общая стоимость закупок, тыс. руб.',
		'---' AS 'Средний размер скидки, %',
		'---' AS 'Экономия от бюджета, тыс. руб.',
		'---' AS  'Экономия от бюджета, %'
	FROM `purchases_db`.`purchases_full` AS `purch_f`
	LEFT OUTER JOIN `purchases_db`.`purchase_status` AS `status`
		ON `purch_f`.`id` = `status`.`purchases_id`
		AND `status`.`events_id` = 9
	LEFT OUTER JOIN `purchases_db`.`winners` AS `winners`
		ON `purch_f`.`id` = `winners`.`purchases_id`
	WHERE
		YEAR(`status`.`date`) = `year_arg`
		AND `purch_f`.`other_procurement_register_id` IS NOT NULL
    
    UNION ALL

	SELECT
		(@`row_number`:=@`row_number` + 1) AS '№ п/п',
		'КРОМЕ ТОГО несостоявшихся (отменённых) закупок' AS 'Тип закупки',
		COUNT(`purch_f`.`id`) AS 'Количество закупок',
		SUM(`purch_f`.`planned_cost_thou_of_rub`) AS 'Общая стоимость по бюджету, тыс. руб.',
		'---' AS 'Общая стоимость закупок, тыс. руб.',
		'---' AS 'Средний размер скидки, %',
		'---' AS 'Экономия от бюджета, тыс. руб.',
		'---' AS 'Экономия от бюджета, %'
	FROM `purchases_db`.`purchases_full` AS `purch_f`
	LEFT OUTER JOIN `purchases_db`.`purchase_status` AS `status`
		ON `purch_f`.`id` = `status`.`purchases_id`
		AND `status`.`events_id` = 10
	WHERE
		YEAR(`status`.`date`) = `year_arg`;
END//
DELIMITER ;