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


-- If a phone number is not provided for a new dealership, 
-- set the phone number to the default customer care number 777-111-0305.

CREATE OR replace FUNCTION default_phone_num()
	RETURNS trigger
	LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE dealerships
	SET phone = '777-111-0305'
	WHERE phone IS NULL AND dealership_id = NEW.dealership_id;
	RETURN NULL;
END;
$$

CREATE trigger add_phone
	AFTER INSERT
	ON dealerships
	for each row
  EXECUTE PROCEDURE default_phone_num();
  
INSERT INTO dealerships(business_name, city, state, website, tax_id)
VALUES ('New Dealership in Music City', 'Nashville', 'Tennessee', 'www.test.com', 'ab-200-2000');

SELECT * FROM dealerships ORDER BY dealership_id DESC;


-- OR

create or replace function set_default_dealer_phone()
returns trigger
language PlPGSQL
AS $$
begin
	if new.phone is NULL then
		update dealerships
		set phone = '777-111-0305'
		where dealership_id = new.dealership_id;
	end if;
	
	return null;
end;
$$

create trigger default_dealer_phone
after insert
on dealerships
for each row execute procedure set_default_dealer_phone();

-- OR

CREATE OR REPLACE FUNCTION set_default_phone() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
	IF NEW.phone IS NULL THEN
  		NEW.phone := '777-111-0305';
	END IF;
	RETURN NEW;
END;
$$

CREATE TRIGGER dealership_phone_number 
BEFORE INSERT
ON dealerships
FOR EACH ROW EXECUTE PROCEDURE set_default_phone();

-- For accounting purposes, the name of the state needs to be part of the dealership's tax id. 
-- For example, if the tax id provided is bv-832-2h-se8w for a dealership in Virginia, 
-- then it needs to be put into the database as bv-832-2h-se8w--virginia.

CREATE OR REPLACE FUNCTION set_state_in_tax_id() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
 	IF OLD.tax_id NOT LIKE '%-%-%-%--%' AND NEW.tax_id NOT LIKE '%-%-%-%--%' THEN
		NEW.tax_id := 	CONCAT(NEW.tax_id, '--', LOWER(NEW.state));
   	END IF;
	RETURN NEW;
END;
$$

CREATE TRIGGER dealership_tax_id
BEFORE INSERT OR UPDATE
ON dealerships
FOR EACH ROW EXECUTE PROCEDURE set_state_in_tax_id();

UPDATE dealerships
SET business_name = 'The Last Dealership'
-- 	tax_id = 'wv-353-xu-18ff--alabama'
WHERE dealership_id = 1000;

INSERT INTO dealerships(business_name, city, state, website, tax_id)
VALUES ('New Dealership in Music City', 'Nashville', 'Tennessee', 'www.test.com', 'ab-200-2000-6a');

SELECT * FROM dealerships ORDER BY dealership_id DESC;
