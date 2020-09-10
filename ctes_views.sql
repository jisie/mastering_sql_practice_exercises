-- Common Table Expressions

WITH vehicle_make_models AS
(
	SELECT
	  v.vin,
	  bt.name AS body_type,
	  ma.name AS make,
	  mo.name AS model
	FROM
	  vehicles v
	  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
	  JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
	  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
)
SELECT vin, make, model, body_type FROM vehicle_make_models WHERE body_type = 'Car';

-- Views

CREATE VIEW vehicle_make_models_view AS
SELECT
	  v.vin,
	  bt.name AS body_type,
	  ma.name AS make,
	  mo.name AS model
	FROM
	  vehicles v
	  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
	  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
	  JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
	  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id;

SELECT vin, make, model FROM vehicle_make_models_view WHERE body_type = 'Truck';
SELECT vin, make, model FROM vehicle_make_models_view WHERE body_type = 'Car';
SELECT vin, make, model FROM vehicle_make_models_view WHERE body_type = 'SUV';
