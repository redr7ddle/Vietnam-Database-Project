-- Adair Kelley, Javier Soza
-- adair.kelley@vanderbilt.edu, roberto.j.soza@vanderbilt.edu
-- Project 2

USE vietnamOperations;

-- CLEAN UP DATA --
SET SQL_SAFE_UPDATES = 0;

-- CALL delete_null_dup_id;
-- CALL delete_dup_source_id;
-- CALL truncate_db;

-- remaining information
DROP TABLE IF EXISTS base_bombing_info;
CREATE TABLE IF NOT EXISTS base_bombing_info (
	thor_data_viet_id INT UNSIGNED,
	weapon_type VARCHAR(30) DEFAULT NULL,
	mil_service VARCHAR(6) DEFAULT NULL,
	aircraft_root VARCHAR(10) DEFAULT NULL,
	source_id INT UNSIGNED DEFAULT NULL,
	id INT UNSIGNED DEFAULT NULL,
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
    
-- weapon information
DROP TABLE IF EXISTS weapon_info;
CREATE TABLE IF NOT EXISTS weapon_info (
	thor_data_viet_id INT UNSIGNED,
	weapon_type VARCHAR(30),
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
	mil_service VARCHAR(6),
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
	thor_data_viet_id INT UNSIGNED,
	id INT UNSIGNED,
	airforce_group DECIMAL(5,2) DEFAULT NULL,
	airforce_sqdn VARCHAR(10) DEFAULT NULL,
	release_flt_speed DECIMAL(8,1) DEFAULT NULL,
	resultsbda VARCHAR(20) DEFAULT NULL,
	time_off_target DECIMAL(8,1) DEFAULT NULL,
	PRIMARY KEY(thor_data_viet_id, id),
	CONSTRAINT
		FOREIGN KEY (thor_data_viet_id)
		REFERENCES base_bombing_info (thor_data_viet_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
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
