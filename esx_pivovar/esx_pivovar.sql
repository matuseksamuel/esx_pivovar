INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
	('society_pivovar','Pivovar',1)
;

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
	('society_pivovar','Pivovar', 1)
;
INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
	('society_pivovar', 'Pivovar', 1)
;

INSERT INTO `jobs`(`name`, `label`, `whitelisted`) VALUES
	('pivovar', 'Pivovar', 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('pivovar',0,'recrue','Novacek', 500,'{}','{}'),
	('pivovar',1,'novice','Pokrocily', 750,'{}','{}'),
	('pivovar',2,'cdisenior','Zkuseny', 1200,'{}','{}'),
	('pivovar',3,'boss','Reditel', 1600,'{}','{}')
;

INSERT INTO `items` (`name`, `label`) VALUES
	('chmel', 'Chmel'),
	('nealko', 'Nealkoholicke Pivo'),
	('plzen', 'Pilsner Urquell'),
	('radegast', 'Radegast')
;

