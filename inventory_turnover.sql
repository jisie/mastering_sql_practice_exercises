-- Across all dealerships, which model of vehicle has the lowest current inventory?
-- This will help dealerships know which models the purchase from manufacturers.
SELECT
  mo.name,
  COUNT(v.vehicle_id)
FROM
  vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  mo.vehicle_model_id
ORDER BY
  COUNT(v.vehicle_id) ASC;

-- Across all dealerships, which model of vehicle has the highest current inventory? 
-- This will help dealerships know which models are, perhaps, not selling.
SELECT
  mo.name,
  COUNT(v.vehicle_id)
FROM
  vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  mo.vehicle_model_id
ORDER BY
  COUNT(v.vehicle_id) DESC;

-- Which dealerships are currently selling the least number of vehicle models? 
-- This will let dealerships market vehicle models more effectively per region.
SELECT
  d.business_name,
  COUNT(mo.vehicle_model_id)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  d.dealership_id
ORDER BY
  COUNT(mo.vehicle_model_id);

-- Which dealerships are currently selling the highest number of vehicle models? 
-- This will let dealerships know which regions have either a high population, or less brand loyalty.
SELECT
  d.business_name,
  COUNT(mo.vehicle_model_id)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  d.dealership_id
ORDER BY
  COUNT(mo.vehicle_model_id) DESC;
