SET @`year_arg`:= 2021;
SELECT 
	`plan`.`reporting_year` AS 'Отчётный год',
	`plan`.`number_within_year` AS 'Номер закупки',
	`plan`.`purchase_name` AS 'Наименование закупки',
	`dep`.`department_name_full` AS 'Заказывающее подразделение',
	`prod_tp`.`product_type` AS 'Тип закупаемой продукции',
	`purch_tp`.`purchase_type` AS 'Тип закупки',
	`plan`.`planned_cost_thou_of_rub` AS 'Запланированная стоимость, тыс. руб.',
	`plan`.`date_start` AS 'Запланированная дата начала',
	`plan`.`date_finish` AS 'Запланированная дата завершения'
FROM `purchases_db`.`procurement_plan` AS `plan`
LEFT OUTER JOIN `purchases_db`.`departments` AS `dep`
	ON `plan`.`departments_id` = `dep`.`id`
LEFT OUTER JOIN `purchases_db`.`products_types` AS `prod_tp`
	ON `plan`.`product_types_id` = `prod_tp`.`id`
LEFT OUTER JOIN `purchases_db`.`purchases_types` AS `purch_tp`
	ON `plan`.`purchase_types_id` = `purch_tp`.`id`
WHERE `plan`.`reporting_year` = @`year_arg`
ORDER BY `plan`.`number_within_year`;