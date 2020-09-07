-- Which employees were hired this month?
-- Which employees were hired this year?
-- Which employee has been working the longest at each dealership?
-- What are the 10 most veteran employees across all dealerships in the Carnival platform?


-- How many emloyees are there for each role?
SELECT
  et.name,
  COUNT(e.employee_id)
FROM
  employeetypes et
  JOIN employees e ON et.employee_type_id = e.employee_type_id
GROUP BY
  et.employee_type_id 
  
  -- How many finance managers work at each dealership?
SELECT
  d.business_name,
  COUNT(e.employee_id)
FROM
  employeetypes et
  JOIN employees e ON et.employee_type_id = e.employee_type_id
  JOIN dealershipemployees de ON de.employee_id = e.employee_id
  JOIN dealerships d ON de.dealership_id = d.dealership_id
WHERE
  LOWER(et.name) LIKE '%finance%'
GROUP BY
  d.dealership_id;

-- Get the names of the top 3 employees who work shifts at the most dealerships?
SELECT
  e.first_name,
  e.last_name,
  COUNT(d.dealership_id)
FROM
  employees e
  JOIN dealershipemployees de ON de.employee_id = e.employee_id
  JOIN dealerships d ON de.dealership_id = d.dealership_id
GROUP BY
  e.employee_id
ORDER BY
  COUNT(d.dealership_id) DESC
LIMIT
  3;

-- Get a report on the top two employees who has made the most sales through leasing vehicles.
SELECT
  e.first_name,
  e.last_name,
  COUNT(s.sale_id)
FROM
  employees e
  JOIN sales s ON s.employee_id = e.employee_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
GROUP BY
  e.employee_id
ORDER BY
  COUNT(s.sale_id) DESC
LIMIT
  2;

-- Get a report on the the two employees who has made the least number of non-lease sales.
SELECT
  e.first_name,
  e.last_name,
  COUNT(s.sale_id)
FROM
  employees e
  JOIN sales s ON s.employee_id = e.employee_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) NOT LIKE '%lease%'
GROUP BY
  e.employee_id
ORDER BY
  COUNT(s.sale_id) ASC
LIMIT
  2;
