-- What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
  c.state,
  COUNT(s.sale_id)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  c.state
ORDER BY
  COUNT(s.sale_id) DESC
LIMIT
  5;

-- What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
  c.zipcode,
  COUNT(s.sale_id)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  c.zipcode
ORDER BY
  COUNT(s.sale_id) DESC
LIMIT
  5;

-- What are the top 5 dealerships with the most customers?
SELECT
  d.business_name,
  COUNT(c.customer_id)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  d.dealership_id
ORDER BY
  COUNT(c.customer_id) DESC
LIMIT
  5;
