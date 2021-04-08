DROP VIEW IF EXISTS `purchases_db`.`purchases_full`;
CREATE VIEW `purchases_db`.`purchases_full` AS
SELECT
	`purch`.`id` AS 'id',
	`purch`.`procurement_plan_id` AS 'procurement_plan_id',
    `purch`.`other_procurement_register_id` AS 'other_procurement_register_id',
	COALESCE(`plan`.`purchase_name`, `register`.`purchase_name`) AS 'purchase_name',
    `dep`.`department_name_full` AS 'department_name_full',
    `dep`.`department_name_short` AS 'department_name_short',
	`prod_tp`.`product_type` AS 'product_type',
	COALESCE(`plan`.`purchase_types_id`, `register`.`purchase_types_id`) AS 'purchase_types_id',
	`purch_tp`.`purchase_type` AS 'purchase_type',
	COALESCE(`plan`.`planned_cost_thou_of_rub`, `register`.`planned_cost_thou_of_rub`) AS 'planned_cost_thou_of_rub',
    `plan`.`date_start` AS 'date_start',
    `plan`.`date_finish` AS 'date_finish',
	`purch`.`comment` AS 'comment'
FROM `purchases_db`.`purchases` AS `purch`
LEFT OUTER JOIN `purchases_db`.`procurement_plan` AS `plan`
	ON `purch`.`procurement_plan_id` = `plan`.`id`
LEFT OUTER JOIN `purchases_db`.`other_procurement_register` AS `register`
	ON `purch`.`other_procurement_register_id` = `register`.`id`
LEFT OUTER JOIN `purchases_db`.`departments` AS `dep`
	ON `plan`.`departments_id` = `dep`.`id`
	OR `register`.`departments_id` = `dep`.`id`
LEFT OUTER JOIN `purchases_db`.`products_types` AS `prod_tp`
	ON `plan`.`product_types_id` = `prod_tp`.`id`
	OR `register`.`product_types_id` = `prod_tp`.`id`
LEFT OUTER JOIN `purchases_db`.`purchases_types` AS `purch_tp`
	ON `plan`.`purchase_types_id` = `purch_tp`.`id`
	OR `register`.`purchase_types_id` = `purch_tp`.`id`
ORDER BY `purch`.`id`;