-- Adair Kelley, Javier Soza
-- adair.kelley@vanderbilt.edu, roberto.j.soza@vanderbilt.edu
-- Project 2

SET GLOBAL sql_mode = 'NO_ENGINE_SUBSTITUTION';

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
 LOAD DATA INFILE 'C:/wamp64/tmp/Truncated.csv'
-- 	LOAD DATA INFILE '~/CS-3265-Project2/Truncate.csv'
	INTO TABLE vietnam_bombing_operations
	FIELDS TERMINATED BY '$'
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES;
    
