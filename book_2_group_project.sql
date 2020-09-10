-- Which employees generate the most income per dealership?

SELECT
  DISTINCT ON (d.dealership_id) d.dealership_id,
  d.business_name,
  e.employee_id,
  e.first_name,
  e.last_name,
  SUM(s.price) total_price
FROM
  sales s
  JOIN employees e ON e.employee_id = s.employee_id
  JOIN dealerships d ON d.dealership_id = s.dealership_id
GROUP BY
  d.dealership_id, e.employee_id
ORDER BY
  d.dealership_id, total_price DESC; 

SELECT d.business_name, CONCAT(e.first_name, ' ', e.last_name) AS "Top Employee"			
FROM dealerships d
JOIN employees e ON e.employee_id = (SELECT e.employee_id
									FROM sales s
									JOIN employees e ON s.employee_id = e.employee_id
									WHERE s.dealership_id = d.dealership_id
									GROUP BY e.employee_id, s.dealership_id
									ORDER BY SUM(s.price) DESC
									LIMIT 1)
ORDER BY d.dealership_id;
