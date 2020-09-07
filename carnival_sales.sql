-- Write a query that shows the total purchase sales income per dealership.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  d.dealership_id;

-- Write a query that shows the purchase sales income per dealership for the current month.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE
  date_part('month', s.purchase_date) = date_part('month', CURRENT_DATE) -- AND date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the purchase sales income per dealership for the current year.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE
  date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the total lease income per dealership.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
GROUP BY
  d.dealership_id;

-- Write a query that shows the lease income per dealership for the current month.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
  AND date_part('month', s.purchase_date) = date_part('month', CURRENT_DATE) -- AND date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the lease income per dealership for the current year.
SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
  AND date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the total income (purchase and lease) per employee.
SELECT
  CONCAT(e.first_name, ' ', e.last_name) AS employee,
  SUM(s.price)
FROM
  sales s
  JOIN employees e ON s.employee_id = e.employee_id
GROUP BY
  e.employee_id;
