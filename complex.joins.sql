-- Produce a report that lists every dealership, the number of purchases done by each, and the number of leases done by each.
SELECT
  d.business_name,
  COUNT(s.sale_id) as number_of_sales
FROM
  dealerships d
  JOIN sales s ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  st.sales_type_id = 1
GROUP BY
  d.dealership_id
ORDER BY
  d.dealership_id;

SELECT
  d.business_name,
  COUNT(s.sale_id) as number_of_sales
FROM
  dealerships d
  JOIN sales s ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  st.sales_type_id = 2
GROUP BY
  d.dealership_id
ORDER BY
  d.dealership_id;

-- OR
SELECT
  d.business_name,
  st.name,
  COUNT(s.sale_id) as number_of_sales
FROM
  dealerships d
  JOIN sales s ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
GROUP BY
  d.dealership_id,
  st.sales_type_id
ORDER BY
  d.dealership_id;

-- OR
SELECT
  business_name,
  COUNT(sp.sale_id) AS purchases,
  COUNT(sl.sale_id) AS leases
FROM
  Dealerships d
  LEFT JOIN sales sp on sp.dealership_id = d.dealership_id
  AND sp.sales_type_id = 1
  LEFT JOIN sales sl on sl.dealership_id = d.dealership_id
  AND sl.sales_type_id = 2
GROUP BY
  business_name;

-- Produce a report that determines the most popular vehicle model that is leased.
SELECT
  mo.name,
  COUNT(s.sale_id) AS lease_count
FROM
  sales s
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
WHERE
  s.sales_type_id = 2
GROUP BY
  mo.vehicle_model_id
ORDER BY
  COUNT(s.sale_id) DESC;

-- What is the most popular vehicle make in terms of number of sales?
SELECT
  ma.name,
  COUNT(s.sale_id) AS number_of_sales
FROM
  sales s
  JOIN salestypes st ON st.sales_type_id = s.sales_type_id
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
GROUP BY
  ma.vehicle_make_id
ORDER BY
  COUNT(s.sale_id) DESC;

-- Which employee type sold the most of that make?
SELECT
  et.name,
  COUNT(s.employee_id)
FROM
  sales s
  JOIN vehicles v ON s.vehicle_id = v.vehicle_id
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
  JOIN employees e ON s.employee_id = e.employee_id
  JOIN employeetypes et ON et.employee_type_id = e.employee_type_id
WHERE
  ma.vehicle_make_id = (
    SELECT
      ma.vehicle_make_id
    FROM
      sales s
      JOIN vehicles v ON s.vehicle_id = v.vehicle_id
      JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
      JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
      JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
    GROUP BY
      ma.vehicle_make_id
    ORDER BY
      COUNT(s.sale_id) DESC
    LIMIT
      1
  )
GROUP BY
  et.employee_type_id
ORDER BY
  COUNT(s.employee_id) DESC;
