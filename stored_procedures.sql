create table OilChangeLogs (
  oil_change_log_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  date_occured timestamp with time zone,
  vehicle_id int,
  FOREIGN KEY (vehicle_id) REFERENCES Vehicles (vehicle_id)
);

create table RepairTypes (
  repair_type_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(50)
);

create table CarRepairTypeLogs (
  car_repair_type_log_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  date_occured timestamp with time zone,
  vehicle_id int,
  repair_type_id INT,
  FOREIGN KEY (vehicle_id) REFERENCES Vehicles (vehicle_id),
  FOREIGN KEY (repair_type_id) REFERENCES RepairTypes (repair_type_id)
);

ALTER TABLE
  vehicles
ADD
  COLUMN is_sold BOOLEAN DEFAULT FALSE;
  
ALTER TABLE
  sales
ADD
  COLUMN returned BOOLEAN DEFAULT FALSE;

-- Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs. 
-- They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table. 
-- When set to True this flag will indicate that the vehicle is no longer available in the inventory. 
-- Why not delete this vehicle? We don't want to delete it because it is attached to a sales record.

-- Selling a vehicle
CREATE PROCEDURE remove_vehicle_from_inventory(vehicleId int) LANGUAGE plpgsql AS $ $ BEGIN
UPDATE
  vehicles v
SET
  is_sold = true
WHERE
  v.vehicle_id = vehicleId;

END $ $;

CALL remove_vehicle_from_inventory(2);

CALL remove_vehicle_from_inventory(3);

CALL remove_vehicle_from_inventory(55);

-- Carnival would also like to handle the case for when a car gets returned by a customer. 
-- When this occurs they must add the car back to the inventory and mark the original sales record as returned = True.

CREATE OR REPLACE PROCEDURE return_sold_vehicle(in vehicleId int)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE sales
	SET returned = true
	WHERE vehicle_id = vehicleId;
		
	UPDATE vehicles
	SET is_sold = false
	WHERE vehicle_id = vehicleId;
	
END
$$;

SELECT v.vehicle_id, v.vin, s.returned, v.is_sold FROM sales s
JOIN vehicles v ON v.vehicle_id = s.vehicle_id
WHERE v.vehicle_id = 1;

CALL return_sold_vehicle(1);

-- Carnival staff are required to do an oil change on the returned car before putting it back on the sales floor. 
-- In our stored procedure, we must also log the oil change within the OilChangeLog table.

CREATE OR REPLACE PROCEDURE return_sold_vehicle_with_oil_change(in vehicleId int)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE sales
	SET returned = true
	WHERE vehicle_id = vehicleId;
		
	UPDATE vehicles
	SET is_sold = false
	WHERE vehicle_id = vehicleId;
	
	INSERT INTO oilchangelogs(date_occured, vehicle_id)
	VALUES (CURRENT_DATE, vehicleId);
	
END
$$;

SELECT v.vehicle_id, v.vin, s.returned, v.is_sold, o.date_occured FROM vehicles v
LEFT JOIN sales s ON v.vehicle_id = s.vehicle_id
LEFT JOIN oilchangelogs o ON v.vehicle_id = o.vehicle_id
WHERE v.vehicle_id = 2;

CALL return_sold_vehicle_with_oil_change(2);
