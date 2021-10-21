-- Adair Kelley, Javier Soza
-- adair.kelley@vanderbilt.edu, roberto.j.soza@vanderbilt.edu
-- Project 2

USE vietnamOperations;
SET SQL_SAFE_UPDATES = 0;

DROP PROCEDURE IF EXISTS delete_null_dup_id;
DELIMITER //
CREATE PROCEDURE delete_null_dup_id()
BEGIN
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
    
    SELECT "delete_null_dup_id procedure has completed.";
END //

-- delete 627,403 rows with duplicate source_id based on greater thor_data_viet_id
DROP PROCEDURE IF EXISTS delete_dup_source_id;
DELIMITER //
CREATE PROCEDURE delete_dup_source_id()
BEGIN
	DELETE operation1 FROM vietnam_bombing_operations operation1, vietnam_bombing_operations operation2 
	WHERE operation1.thor_data_viet_id > operation2.thor_data_viet_id AND operation1.source_id = operation2.source_id;
	SELECT "delete_dup_source_id procedure has completed.";
END //

-- delete 65% of database (https://stackoverflow.com/questions/4741239/select-top-x-or-bottom-percent-for-numeric-values-in-mysql)
DROP PROCEDURE IF EXISTS truncate_db;
DELIMITER //
CREATE PROCEDURE truncate_db()
BEGIN
	SELECT ROUND(COUNT(*) * 75/100) 
    FROM vietnam_bombing_operations
    INTO @rows;
	PREPARE STMT FROM "DELETE FROM vietnam_bombing_operations WHERE thor_data_viet_id IN
	(SELECT * FROM vietnam_bombing_operations ORDER BY thor_data_viet_id LIMIT ?)";
	EXECUTE STMT USING @rows;
	SELECT "truncate_db procedure has completed.";
END //
