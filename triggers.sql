DROP TRIGGER new_sale_made ON sales;
DROP FUNCTION set_pickup_date;

CREATE FUNCTION set_pickup_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
  -- trigger function logic
  UPDATE sales
  SET pickup_date = NEW.purchase_date + interval '7 days'
  WHERE sales.sale_id = NEW.sale_id;
  
  RETURN NULL;
END;
$$

CREATE TRIGGER new_sale_made
  AFTER INSERT
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE set_pickup_date();

INSERT INTO sales(sales_type_id, vehicle_id, employee_id, dealership_id, price, invoice_number, purchase_date, pickup_date)
VALUES (1, 11, 111, 111, 10111, 101010101, CURRENT_DATE, CURRENT_DATE);

SELECT * FROM sales
ORDER BY sale_id DESC;

-- Create a trigger for when a new Sales record is added, 
-- set the purchase date to 3 days from the current date.

CREATE OR REPLACE FUNCTION set_purchase_date()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
AS $$
BEGIN 
	UPDATE sales 
	SET purchase_date = current_date + 3
	WHERE sales.sale_id = NEW.sale_id;
	RETURN NULL;
END;
$$
CREATE TRIGGER new_sale_added
	AFTER INSERT
	ON sales
	FOR EACH ROW
	EXECUTE PROCEDURE set_purchase_date();
	
INSERT INTO sales(sales_type_id, vehicle_id, employee_id, dealership_id, price, invoice_number)
VALUES 
(1, 11, 111, 111, 10111, 101010101),
(1, 12, 111, 111, 34332, 202020202),
(1, 13, 111, 111, 64728, 303030303),
(1, 14, 111, 111, 29512, 404040404);

SELECT * FROM sales
ORDER BY sale_id DESC;

-- Create a trigger for updates to the Sales table.

-- If the pickup date is on or before the purchase date, 
-- set the pickup date to 7 days after the purchase date. 

-- If the pickup date is after the purchase date but less than 7 days out from the purchase date, 
-- add 4 additional days to the pickup date.

CREATE OR REPLACE FUNCTION conditionally_set_pickup_date() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
	IF NEW.pickup_date > NEW.purchase_date AND NEW.pickup_date <= NEW.purchase_date  + integer '7' THEN
	  NEW.pickup_date := NEW.pickup_date + integer '4';
	ELSIF NEW.pickup_date <= NEW.purchase_date THEN
	  NEW.pickup_date := NEW.purchase_date + integer '7';
	END IF;
  
  RETURN NEW;
END;
$$

CREATE TRIGGER update_sale_made_pickup_date
  BEFORE UPDATE
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE conditionally_set_pickup_date();
  
  
UPDATE sales
SET pickup_date = purchase_date + 1
WHERE sale_id > 1008;

SELECT * FROM sales
ORDER BY sale_id DESC;

-- Because Carnival is a single company, 
-- we want to ensure that there is consistency in the data provided to the user. 
-- Each dealership has it's own website but we want to make sure the website URL are consistent and easy to remember. 
-- Therefore, any time a new dealership is added or an existing dealership is updated, 
-- we want to ensure that the website URL has the following format: 
-- http://www.carnivalcars.com/{name of the dealership with underscores separating words}.

CREATE OR REPLACE FUNCTION format_dealership_webiste() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
-- 	NEW.website := CONCAT('http://www.carnivalcars.com/', REGEXP_REPLACE(LOWER(NEW.business_name), '( ){1,}', '_', 'g'));
	NEW.website := CONCAT('http://www.carnivalcars.com/', REPLACE(LOWER(NEW.business_name), ' ', '_'));
	
	RETURN NEW;
END;
$$

CREATE TRIGGER dealership_website
BEFORE INSERT OR UPDATE
ON dealerships
FOR EACH ROW EXECUTE PROCEDURE format_dealership_webiste();

INSERT INTO dealerships(business_name, phone, city, state, website, tax_id)
VALUES ('New Dealership in Music City', '615-200-2000', 'Nashville', 'Tennessee', 'www.test.com', 'ab-200-2000');

SELECT * FROM dealerships ORDER BY dealership_id DESC;
