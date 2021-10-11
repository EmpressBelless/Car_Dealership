CREATE TABLE mechanic (
	mechanic_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	employee_email VARCHAR(100)
)

CREATE TABLE car_service (
	service_ticket SERIAL PRIMARY KEY,
	customer_id INTEGER,
	vin_number VARCHAR(100),
	mechanic_id INTEGER,
	description VARCHAR(250),
	payment_amount NUMERIC(8,2),
	date_serviced TIMESTAMP,
	part_id INTEGER,
	quantity_used INTEGER
);

CREATE TABLE parts (
	part_id SERIAL PRIMARY KEY,
	part_name VARCHAR(50),
	description VARCHAR(225),
	price NUMERIC(6,2),
	quantity INTEGER
);

CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	phone_number VARCHAR(20),
	email VARCHAR(50),
	vin_number VARCHAR(100)
);

CREATE TABLE salesperson (
	sales_emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	employee_email VARCHAR(100)
);

CREATE TABLE car_invoice (
	invoice_id SERIAL PRIMARY KEY,
	sales_emp_id INTEGER,
	customer_id INTEGER,
	vin_number VARCHAR(100),
	date_created TIMESTAMP
);

CREATE TABLE car_inventory (
	vin_number VARCHAR(100) PRIMARY KEY,
	year_ INTEGER,
	make VARCHAR(50),
	model VARCHAR(50),
	miles INTEGER,
	used_or_new VARCHAR(4),
	amount NUMERIC(10,2)
);

ALTER TABLE car_service 
ADD FOREIGN KEY (customer_id)REFERENCES customers(customer_id),
ADD FOREIGN KEY (mechanic_id) REFERENCES mechanic(mechanic_id),
ADD FOREIGN KEY (part_id) REFERENCES parts(part_id);

ALTER TABLE car_invoice
ADD FOREIGN KEY (sales_emp_id) REFERENCES salesperson(sales_emp_id),
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
ADD FOREIGN KEY (vin_number) REFERENCES car_inventory(vin_number);


CREATE or REPLACE PROCEDURE AddCustomers
(
	cust_id INTEGER,
	f_name VARCHAR(50),
	l_name VARCHAR(50),
	phone VARCHAR(20),
	email_address VARCHAR(50),
	vin VARCHAR(100)
)
LANGUAGE plpgsql AS
$$
BEGIN
	Insert INTO Customers (first_name, last_name, phone_number, email, vin_number)
	VALUES (
	f_name,
	l_name,
	phone,
	email_address,
	vin
	) RETURNING customer_id into cust_id;
END
$$; 

CALL Addcustomers(null, 'Bob', 'Barker', '518-867-5309','bob.barker@priceisright.com', 'GHI17890HIJK44567')

SELECT * FROM customers

UPDATE customers
SET email = 'bob.barker@priceisright.com'
WHERE first_name = 'Bob'

CALL Addcustomers(null, 'Drew', 'Carey', '555-555-5535', 'drew.carey@priceisright.com', 'GHGH3453G9013309')

Insert INTO car_inventory (vin_number, year_, make, model, miles, used_or_new, amount)
VALUES 
('GHI17890HIJK44567', 2004, 'Chevy', 'Silverado', 200000, 'used', 10000),
('GHGH4563G9013309', 2006, 'Jeep', 'Wrangler', 194000, 'used', 8000);
-- self note. could not keep commas in miles or dollar amount
SELECT * from car_inventory

INSERT INTO salesperson (first_name, last_name, employee_email)
VALUES
('Paul', 'Ruzek', 'p.ruzek@domsshop.com'),
('Jake', 'Gilligan', 'j.gilligan@domshop.com');
SELECT * from salesperson


select * FROM CAR_INVOICE

INSERT INTO car_invoice (vin_number)
VALUES ((select vin_number from car_inventory WHERE year_ = 2006));

UPDATE car_invoice
SET date_created = '2021-10-10'
WHERE vin_number = 'GHGH4563G9013309'

INSERT INTO car_invoice (vin_number, date_created)
VALUES ((select vin_number from car_inventory WHERE year_ = 2004), NOW());

UPDATE car_invoice
SET customer_id = (Select customer_id from customers Where customer_id = 1)
Where invoice_id = 2

UPDATE car_invoice
SET customer_id = (Select customer_id from customers Where customer_id = 2)
Where invoice_id = 1

Update car_invoice
SET sales_emp_id = 2
Where customer_id = 2

INSERT INTO car_service (description, payment_amount, date_serviced, quantity_used)
VALUES
( 'tire alignment', '100', NOW(), null),
( 'transmission', '9999', NOW(), 1);
select * from customers
Update car_service
SET customer_id = (Select customer_id from customers Where first_name = 'Bob')
Where payment_amount = '100'

Update car_service
SET vin_number = (Select vin_number from customers where first_name = 'Bob')
Where payment_amount = '100'

Update car_service 
Set mechanic_id = 1
Where customer_id = 1
SELECT * from car_service

Update car_service
Set vin_number = (Select vin_number from customers where first_name = 'Drew')
Where description = 'transmission'

Update car_service
Set customer_id = 2
Where description = 'transmission'

Update car_service
Set mechanic_id = 2
Where customer_id = 2

Update car_service
Set part_id = (Select part_id from parts where part_name='Transmission')
Where payment_amount = 9999.00

INSERT INTO mechanic (first_name, last_name, employee_email)
VALUES
('Jerry', 'Knowles', 'Jerry.Knowles@domsshop.com'),
('Lester', 'Pickle', 'Lester.Pickle@domsshop.com');

SELECT * from mechanic

INSERT INTO parts (part_id, part_name, description, price, quantity)
VALUES
(5687, 'Transmission', 'Jeep Wrangler tranny', 9999, 1);
(8989,'Goodyear tire', 'Generic tire, common size', 125, 4),
(8732,'Air filter', 'Common air filter for sedans', 14, 50);

SELECT * from parts

-- Notes to self. You can use subqueries to update rows where FK is attached. 
-- to do figure out how to change the sequence and reset the sequence in postgresql.
