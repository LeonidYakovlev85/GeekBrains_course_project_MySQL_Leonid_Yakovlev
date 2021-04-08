DROP VIEW IF EXISTS `purchases_db`.`purchase_status_full`;
CREATE VIEW `purchases_db`.`purchase_status_full` AS
SELECT
	`status`.`id` AS 'status_id',
    `status`.`purchases_id` AS 'purchases_id',
    `status`.`events_id` AS 'events_id',
    `events`.`event_name` AS 'event_name',
    `status`.`date` AS 'date',
    `stages`.`stage_name` AS 'stage_name',
    `status`.`approximate_date` AS 'approximate_date',
    CONCAT(`resp`.`last_name`, ' ', `resp`.`first_name`, ' ', `resp`.`middle_name`, ', ', LOWER(`resp`.`position`)) AS 'responsible',
    `resp`.`initials` AS 'responsible_initials'
FROM `purchases_db`.`purchase_status` AS `status`
LEFT OUTER JOIN `purchases_db`.`events` AS `events`
	ON `status`.`events_id` = `events`.`id`
LEFT OUTER JOIN `purchases_db`.`stages` AS `stages`
	ON `status`.`stages_id` = `stages`.`id`
LEFT OUTER JOIN `purchases_db`.`responsible` AS `resp`
	ON `status`.`responsible_id` = `resp`.`id`
ORDER BY `status`.`id`;