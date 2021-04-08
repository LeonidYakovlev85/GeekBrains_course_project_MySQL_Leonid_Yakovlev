DROP PROCEDURE IF EXISTS `purchases_db`.`specific_purchase_report`;
DELIMITER //
CREATE PROCEDURE `purchases_db`.`specific_purchase_report` (`purchase_id_arg` INT)
BEGIN
	SELECT
		CASE
			WHEN `status_f`.`status_id` = `purchases_db`.`first_status_id`(`purch_f`.`id`) THEN `purch_f`.`id`
			ELSE '-//-'
		END AS 'Номер закупки',
		CASE
			WHEN `status_f`.`status_id` = `purchases_db`.`first_status_id`(`purch_f`.`id`) THEN `purch_f`.`purchase_name`
			ELSE '-//-'
		END AS 'Наименование закупки',
		CASE
			WHEN `status_f`.`status_id` = `purchases_db`.`first_status_id`(`purch_f`.`id`) THEN `purch_f`.`department_name_full`
			ELSE '-//-'
		END AS 'Заказывающее подразделение',
		CASE
			WHEN `status_f`.`status_id` = `purchases_db`.`first_status_id`(`purch_f`.`id`) THEN `purch_f`.`product_type`
			ELSE '-//-'
		END AS 'Тип закупаемой продукции',
		CASE
			WHEN `status_f`.`status_id` = `purchases_db`.`first_status_id`(`purch_f`.`id`) THEN `purch_f`.`purchase_type`
			ELSE '-//-'
		END AS 'Тип закупки',
		CASE
			WHEN `status_f`.`status_id` = `purchases_db`.`first_status_id`(`purch_f`.`id`) THEN `purch_f`.`planned_cost_thou_of_rub`
			ELSE '-//-'
		END AS 'Запланированная стоимость, тыс. руб.',
		CASE
			WHEN `status_f`.`status_id` = `purchases_db`.`first_status_id`(`purch_f`.`id`) THEN `purch_f`.`date_start`
			ELSE '-//-'
		END AS 'Запланированная дата начала',
		CASE
			WHEN `status_f`.`status_id` = `purchases_db`.`first_status_id`(`purch_f`.`id`) THEN `purch_f`.`date_finish`
			ELSE '-//-'
		END AS 'Запланированная дата завершения',
		`status_f`.`event_name` AS 'Событие',
		`status_f`.`date` AS 'Дата события',
		`status_f`.`responsible` AS 'Ответственный',
        COALESCE(`doc_reg`.`protocol_number`, '---') AS 'Номер протокола',
        COALESCE(`doc_reg`.`protocol_url`, '---') AS 'Ссылка на протокол',
        COALESCE(`doc_reg`.`comparison_table_url`, '---') AS 'Ссылка на сопоставительную таблицу',
		CASE
			WHEN `status_f`.`status_id` = `purchases_db`.`first_status_id`(`purch_f`.`id`) THEN COALESCE(`purch_f`.`comment`, '---')
			ELSE '-//-'
		END AS 'Комментарий'
	FROM
		`purchases_db`.`purchases_full` AS `purch_f`
	LEFT OUTER JOIN `purchases_db`.`purchase_status_full` AS `status_f`
		ON `purch_f`.`id` = `status_f`.`purchases_id`
	LEFT OUTER JOIN `purchases_db`.`procurement_documents_register` AS `doc_reg`
		ON `status_f`.`status_id` = `doc_reg`.`purchase_status_id`
	WHERE `purch_f`.`id` = `purchase_id_arg`
	ORDER BY `purch_f`.`id`, `status_f`.`events_id`;
END//
DELIMITER ;