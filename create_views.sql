use vietnamoperations;
CREATE VIEW search_view AS (
  SELECT base_info.thor_data_viet_id, base_info.msn_date, base_info.weapon_type, 
        base_info.takeoff_location, air_root.valid_aircraft_root, military_info.mil_service FROM

    base_bombing_info base_info
  LEFT JOIN 
    aircraft_root_info air_root
  ON
    base_info.aircraft_root = air_root.aircraft_root
  LEFT JOIN
    military_service_country_info military_info
  ON 
    base_info.thor_data_viet_id = military_info.thor_data_viet_id
);