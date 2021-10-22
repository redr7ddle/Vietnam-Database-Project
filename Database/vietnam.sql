-- Adair Kelley, Javier Soza
-- adair.kelley@vanderbilt.edu, roberto.j.soza@vanderbilt.edu
-- Project 2

-- SET GLOBAL sql_mode = 'NO_ENGINE_SUBSTITUTION';
SELECT @@sql_mode;

DROP DATABASE IF EXISTS vietnamOperations;
CREATE DATABASE IF NOT EXISTS vietnamOperations;
USE vietnamOperations;

-- CREATE TABLE
DROP TABLE IF EXISTS vietnam_bombing_operations;
CREATE TABLE IF NOT EXISTS vietnam_bombing_operations (
	thor_data_viet_id INT UNSIGNED NOT NULL,
	country_flying_mission VARCHAR(30) DEFAULT NULL,
	mil_service VARCHAR(6) DEFAULT NULL,
	msn_date DATE DEFAULT NULL,
	source_id INT UNSIGNED DEFAULT NULL,
	source_record VARCHAR(10) NOT NULL CHECK (source_record IN ('CACTA6570', 'CACTA6669', 'SACCOACT', 'SEADAB')),
	valid_aircraft_root VARCHAR(10) DEFAULT NULL,
	takeoff_location VARCHAR(20) DEFAULT NULL,
	tgtlatdd_ddd_wgs84 DECIMAL(40,20) DEFAULT NULL,
	tgtlonddd_ddd_wgs84 DECIMAL(40,20) DEFAULT NULL,
	tgt_type VARCHAR(20) DEFAULT NULL,
	num_weapons_delivered SMALLINT UNSIGNED DEFAULT NULL CHECK (num_weapons_delivered >= 0),
	time_on_target DECIMAL(10, 1) DEFAULT NULL,
	weapon_type VARCHAR(30) DEFAULT NULL,
	weapon_type_class VARCHAR(10) DEFAULT NULL,
	weapon_type_weight SMALLINT UNSIGNED DEFAULT NULL CHECK (weapon_type_weight >= 0),
	aircraft_original VARCHAR(10) DEFAULT NULL,
	aircraft_root VARCHAR(10) DEFAULT NULL,
	airforce_group DECIMAL(5,2) DEFAULT NULL,
	airforce_sqdn VARCHAR(10) DEFAULT NULL,
	call_sign VARCHAR(20) DEFAULT NULL,
	flt_hours INT UNSIGNED DEFAULT NULL CHECK (flt_hours >= 0),
	mfunc VARCHAR(50) DEFAULT NULL,
	mfunc_desc VARCHAR(20) DEFAULT NULL,
	mission_id VARCHAR(10) DEFAULT NULL,
	num_of_acft SMALLINT UNSIGNED DEFAULT NULL,
	operation_supported VARCHAR(10) DEFAULT NULL,
	period_of_day CHAR(1) DEFAULT NULL,
	unit VARCHAR(10) DEFAULT NULL,
	tgt_cloud_cover VARCHAR(10) DEFAULT NULL,
	tgt_control VARCHAR(20) DEFAULT NULL,
	tgt_country VARCHAR(20) DEFAULT NULL,
	tgt_id VARCHAR(10) DEFAULT NULL,
	tgt_orig_coords VARCHAR(20) DEFAULT NULL,
	tgt_orig_coords_format VARCHAR(20) DEFAULT NULL,
	tgt_weather VARCHAR(10) DEFAULT NULL,
	additional_info TEXT DEFAULT NULL,
	geozone CHAR(2) DEFAULT NULL,
	id INT UNSIGNED DEFAULT NULL,
	mfunc_desc_class VARCHAR(10) DEFAULT NULL,
	num_weapons_jettisoned SMALLINT DEFAULT NULL,
	num_weapons_returned SMALLINT DEFAULT NULL,
	release_altitude SMALLINT UNSIGNED DEFAULT NULL,
	release_flt_speed DECIMAL(8,1) DEFAULT NULL,
	resultsbda VARCHAR(20) DEFAULT NULL,
	time_off_target DECIMAL(8,1) DEFAULT NULL,
	weapons_loaded_weight INT UNSIGNED DEFAULT NULL
);


-- Load data
LOAD DATA INFILE 'C:/wamp64/tmp/THOR_Vietnam_Bombing_Operations.csv'
-- LOAD DATA INFILE 'C:/wamp64/tmp/TEST4.csv'
	INTO TABLE vietnam_bombing_operations
	FIELDS TERMINATED BY '$'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
    
-- CLEAN UP DATA --
SET SQL_SAFE_UPDATES = 0;

-- delete 5 null id
DELETE FROM vietnam_bombing_operations
WHERE id IS NULL;

-- delete 135 duplicate id
-- DELETE FROM vietnam_bombing_operations WHERE id NOT IN
-- ( SELECT * FROM 
--     (SELECT MIN(id) FROM vietnam_bombing_operations GROUP BY id) AS temp
-- );
DELETE operation1 FROM vietnam_bombing_operations operation1, vietnam_bombing_operations operation2 
WHERE operation1.thor_data_viet_id > operation2.thor_data_viet_id AND operation1.id = operation2.id;

-- delete 627,403 rows with duplicate source_id based on greater thor_data_viet_id
DELETE operation1 FROM vietnam_bombing_operations operation1, vietnam_bombing_operations operation2 
WHERE operation1.thor_data_viet_id > operation2.thor_data_viet_id AND operation1.source_id = operation2.source_id;

-- delete 75% of database (https://stackoverflow.com/questions/4741239/select-top-x-or-bottom-percent-for-numeric-values-in-mysql)
SELECT @rows := ROUND(COUNT(*) * 75/100) FROM vietnam_bombing_operations;
PREPARE STMT FROM "DELETE FROM vietnam_bombing_operations WHERE thor_data_viet_id IN
(SELECT * FROM vietnam_bombing_operations ORDER BY thor_data_viet_id LIMIT ?)";
EXECUTE STMT USING @rows;



-- weapon information
DROP TABLE IF EXISTS weapon_info;
CREATE TABLE IF NOT EXISTS weapon_info (
	thor_data_viet_id INT UNSIGNED,
	weapon_type VARCHAR(30) DEFAULT NULL,
	weapon_type_weight SMALLINT UNSIGNED DEFAULT NULL CHECK (weapon_type_weight >= 0),
	PRIMARY KEY(thor_data_viet_id, weapon_type),
	CONSTRAINT
		FOREIGN KEY (thor_data_viet_id)
		REFERENCES base_bombing_info (thor_data_viet_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT
		FOREIGN KEY (weapon_type)
		REFERENCES base_bombing_info (weapon_type)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- insertion to weapon_info
INSERT INTO weapon_info (thor_data_viet_id, weapon_type, weapon_type_weight)
    SELECT DISTINCT thor_data_viet_id, weapon_type, weapon_type_weight
    FROM vietnam_bombing_operations;
    
-- military service country information
DROP TABLE IF EXISTS military_service_country_info;
CREATE TABLE IF NOT EXISTS military_service_country_info (
	thor_data_viet_id INT UNSIGNED,
	mil_service VARCHAR(6) DEFAULT NULL,
	country_flying_mission VARCHAR(30) DEFAULT NULL,
	PRIMARY KEY(thor_data_viet_id, mil_service),
	CONSTRAINT
		FOREIGN KEY (thor_data_viet_id)
		REFERENCES base_bombing_info (thor_data_viet_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT
		FOREIGN KEY (mil_service)
		REFERENCES base_bombing_info (mil_service)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- insertion to weapon_info
INSERT INTO military_service_country_info (thor_data_viet_id, mil_service, country_flying_mission)
    SELECT DISTINCT thor_data_viet_id, mil_service, country_flying_mission
    FROM vietnam_bombing_operations;
    
-- aircraft and root information
DROP TABLE IF EXISTS aircraft_root_info;
CREATE TABLE IF NOT EXISTS aircraft_root_info (
	aircraft_root VARCHAR(10),
	valid_aircraft_root VARCHAR(10) DEFAULT NULL,
	PRIMARY KEY(aircraft_root),
	CONSTRAINT
		FOREIGN KEY (aircraft_root)
		REFERENCES base_bombing_info (aircraft_root)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- insertion to aircraft_root_info
INSERT INTO aircraft_root_info (aircraft_root, valid_aircraft_root)
    SELECT DISTINCT aircraft_root, valid_aircraft_root
    FROM vietnam_bombing_operations;

-- source information
DROP TABLE IF EXISTS source_info;
CREATE TABLE IF NOT EXISTS source_info (
	thor_data_viet_id INT UNSIGNED,
	source_id INT UNSIGNED,
	call_sign VARCHAR(20) DEFAULT NULL,
	tgt_control VARCHAR(20) DEFAULT NULL,
	tgt_id VARCHAR(10) DEFAULT NULL,
	release_altitude SMALLINT UNSIGNED DEFAULT NULL,
	PRIMARY KEY(thor_data_viet_id, source_id),
	CONSTRAINT
		FOREIGN KEY (thor_data_viet_id)
		REFERENCES base_bombing_info (thor_data_viet_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	CONSTRAINT
		FOREIGN KEY (source_id)
		REFERENCES base_bombing_info (source_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- insertion to source_info
INSERT INTO source_info (thor_data_viet_id, source_id, call_sign, tgt_control, tgt_id, release_altitude)
    SELECT DISTINCT thor_data_viet_id, source_id, call_sign, tgt_control, tgt_id, release_altitude
    FROM vietnam_bombing_operations;
    
-- id information
DROP TABLE IF EXISTS id_info;
CREATE TABLE IF NOT EXISTS id_info (
	-- thor_data_viet_id INT UNSIGNED,
	id INT UNSIGNED DEFAULT NULL,
	airforce_group DECIMAL(5,2) DEFAULT NULL,
	airforce_sqdn VARCHAR(10) DEFAULT NULL,
	release_flt_speed DECIMAL(8,1) DEFAULT NULL,
	resultsbda VARCHAR(20) DEFAULT NULL,
	time_off_target DECIMAL(8,1) DEFAULT NULL,
	PRIMARY KEY(id),
-- 	PRIMARY KEY(thor_data_viet_id, id),
--  CONSTRAINT
-- 		FOREIGN KEY (thor_data_viet_id)
-- 		REFERENCES base_bombing_info (thor_data_viet_id)
-- 		ON DELETE CASCADE
-- 		ON UPDATE CASCADE,
	CONSTRAINT
		FOREIGN KEY (id)
		REFERENCES base_bombing_info (id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

-- insertion to id_info
INSERT INTO id_info (thor_data_viet_id, id, airforce_group, airforce_sqdn, release_flt_speed, resultsbda, time_off_target)
    SELECT DISTINCT thor_data_viet_id, id, airforce_group, airforce_sqdn, release_flt_speed, resultsbda, time_off_target
    FROM vietnam_bombing_operations;
    
-- remaining information
DROP TABLE IF EXISTS base_bombing_info;
CREATE TABLE IF NOT EXISTS base_bombing_info (
	thor_data_viet_id INT UNSIGNED,
	weapon_type VARCHAR(30) DEFAULT NULL,
	mil_service VARCHAR(6) DEFAULT NULL,
	aircraft_root VARCHAR(10) DEFAULT NULL,
	source_id INT UNSIGNED DEFAULT NULL,
	msn_date DATE DEFAULT NULL,
	source_record VARCHAR(10) DEFAULT NULL,
	takeoff_location VARCHAR(20) DEFAULT NULL,
	tgtlatdd_ddd_wgs84 DECIMAL(40,20) DEFAULT NULL, -- could not use decimal because of null
	tgtlonddd_ddd_wgs84 DECIMAL(40,20) DEFAULT NULL,
	tgt_type VARCHAR(20) DEFAULT NULL,
	num_weapons_delivered SMALLINT UNSIGNED DEFAULT NULL CHECK (num_weapons_delivered >= 0),
	time_on_target DECIMAL(10, 1) DEFAULT NULL,
	weapon_type_class VARCHAR(10) DEFAULT NULL,
	aircraft_original VARCHAR(10) DEFAULT NULL,
	call_sign VARCHAR(20) DEFAULT NULL,
	flt_hours INT UNSIGNED DEFAULT NULL CHECK (flt_hours >= 0),
	mfunc VARCHAR(50) DEFAULT NULL,
	mfunc_desc VARCHAR(20) DEFAULT NULL,
	mission_id VARCHAR(10) DEFAULT NULL,
	num_of_acft SMALLINT UNSIGNED DEFAULT NULL,
	operation_supported VARCHAR(10) DEFAULT NULL,
	period_of_day CHAR(1) DEFAULT NULL,
	unit VARCHAR(10) DEFAULT NULL,
	tgt_cloud_cover VARCHAR(10) DEFAULT NULL,
	tgt_country VARCHAR(20) DEFAULT NULL,
	tgt_orig_coords VARCHAR(20) DEFAULT NULL,
	tgt_orig_coords_format VARCHAR(20) DEFAULT NULL,
	tgt_weather VARCHAR(10) DEFAULT NULL,
	additional_info TEXT DEFAULT NULL,
	geozone CHAR(2) DEFAULT NULL,
	mfunc_desc_class VARCHAR(10) DEFAULT NULL,
	num_weapons_jettisoned SMALLINT DEFAULT NULL,
	num_weapons_returned SMALLINT DEFAULT NULL,
	weapons_loaded_weight INT UNSIGNED DEFAULT NULL, 
    PRIMARY KEY(thor_data_viet_id)
);

-- insertion to base_bombing_info
INSERT INTO base_bombing_info (thor_data_viet_id, weapon_type, mil_service, aircraft_root, source_id, id, msn_date, source_record, takeoff_location, tgtlatdd_ddd_wgs84, tgtlonddd_ddd_wgs84, tgt_type, num_weapons_delivered, time_on_target, weapon_type_class, aircraft_original, call_sign, flt_hours, mfunc, mfunc_desc, mission_id, num_of_acft, operation_supported, period_of_day, unit, tgt_cloud_cover, tgt_country, tgt_orig_coords, tgt_orig_coords_format, tgt_weather, additional_info, geozone, mfunc_desc_class, num_weapons_jettisoned, num_weapons_returned, weapons_loaded_weight)
    SELECT DISTINCT thor_data_viet_id, weapon_type, mil_service, aircraft_root, source_id, id, msn_date, source_record, takeoff_location, tgtlatdd_ddd_wgs84, tgtlonddd_ddd_wgs84, tgt_type, num_weapons_delivered, time_on_target, weapon_type_class, aircraft_original, call_sign, flt_hours, mfunc, mfunc_desc, mission_id, num_of_acft, operation_supported, period_of_day, unit, tgt_cloud_cover, tgt_country, tgt_orig_coords, tgt_orig_coords_format, tgt_weather, additional_info, geozone, mfunc_desc_class, num_weapons_jettisoned, num_weapons_returned, weapons_loaded_weight
    FROM vietnam_bombing_operations;

/*
-- COUNT STATEMENTS --
-- vietnam_bombing_operations count
SELECT COUNT(*) AS vietnam_bombing_operations_count
	FROM vietnam_bombing_operations;

-- weapon_info count
SELECT COUNT(*) AS weapon_info_count
	FROM weapon_info;
    
-- military_service_country count
SELECT COUNT(*) AS military_service_country_info_count
	FROM military_service_country_info;

-- aircraft_root_info count
SELECT COUNT(*) AS aircraft_root_info_count
	FROM aircraft_root_info;

-- source_info count
SELECT COUNT(*) AS source_info_count
	FROM source_info;

-- id_info count
SELECT COUNT(*) AS id_info_count
	FROM id_info;
    
-- base_bombing_info count
SELECT COUNT(*) AS base_bombing_info_count
	FROM base_bombing_info;
    
*/
