-- Rheta Raymen an employee of Carnival has asked to be transferred to a different dealership location. 
-- She is currently at dealership 751. 
-- She would like to work at dealership 20. Update her record to reflect her transfer.

SELECT * FROM dealershipemployees
WHERE employee_id = 680;

SELECT * FROM employees
WHERE first_name LIKE '%Rheta%';
-- Rheta's employee id: 680

UPDATE dealershipemployees
SET dealership_id = 20
WHERE employee_id = 680 AND dealership_id = 751;

-- A Sales associate needs to update a sales record because her customer want so pay wish Mastercard instead of American Express. 
-- Update Customer, Layla Igglesden Sales record which has an invoice number of 2781047589.

SELECT s.invoice_number, s.payment_method, c.customer_id, c.first_name, c.last_name 
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
WHERE s.invoice_number = '2781047589';

UPDATE  sales
SET payment_method = LOWER('Mastercard')
WHERE customer_id = 13;

-- test

SELECT * FROM sales s
WHERE s.customer_id = 13;

-- A sales employee at carnival creates a new sales record for a sale they are trying to close. 
-- The customer, last minute decided not to purchase the vehicle. Help delete the Sales record with an invoice number of '7628231837'.
SELECT * FROM sales
WHERE invoice_number = '7628231837';

DELETE FROM sales
WHERE invoice_number = '7628231837';

-- An employee was recently fired so we must delete them from our database. 
-- Delete the employee with employee_id of 35. What problems might you run into when deleting? 
-- How would you recommend fixing it?

-- OPTION 1

DELETE FROM sales
WHERE employee_id = 35;

DELETE FROM employees
WHERE employee_id = 35;

SELECT * FROM employees
WHERE employee_id = 35;

-- SELECT * FROM dealershipemployees
-- WHERE employee_id = 35;

-- OPTION 2

ALTER TABLE employees
ADD COLUMN isActive bool NOT NULL
DEFAULT TRUE;

SELECT * FROM employees;

UPDATE employees
SET isactive = false
WHERE employee_id = 35;

-- OPTION 3

ALTER table  sales
DROP CONSTRAINT sales_employee_id_fkey,
ADD CONSTRAINT sales_employee_id_fkey
FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE;
	
DELETE FROM employees
WHERE employee_id = 35;
