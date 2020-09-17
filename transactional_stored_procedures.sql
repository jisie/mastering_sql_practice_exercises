CREATE OR REPLACE PROCEDURE new_customer_and_sales()
LANGUAGE plpgsql
AS $$
DECLARE 
  NewCustomerId integer;
  CurrentTS date;
BEGIN
	INSERT INTO customers(first_name,last_name,email,phone,street,city,state,zipcode,company_name)
		VALUES
		('BILL','Simlet','r.simlet@remves.com','615-876-1237','77 Miner Lane','San Jose','CA','95008','Remves') 
		RETURNING customer_id INTO NewCustomerId;

COMMIT;

	CurrentTS = CURRENT_DATE;

	INSERT INTO sales(sales_type_id,vehicle_id,employee_id,customer_id,dealership_id,price,deposit,purchase_date,pickup_date,invoice_number,payment_method)
		VALUES(1,1,1,NewCustomerId,1,24333.67,6500,CurrentTS,CurrentTS + interval '7 days',1273592747, 'solo');
		
COMMIT;
		
	INSERT INTO sales(sales_type_id,vehicle_id,employee_id,customer_id,dealership_id,price,deposit,purchase_date,pickup_date,invoice_number,payment_method)
		VALUES(1,1,1,NewCustomerId,1,24333.67,6500,CurrentTS,CurrentTS + interval '7 days',1273592747, 'duo');

END;
$$;

CALL new_customer_and_sales();
