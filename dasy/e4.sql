DROP TABLE IF EXISTS adresses CASCADE;

CREATE TABLE adresses 
	(adress_id INT PRIMARY KEY,
		street VARCHAR(100) NOT NULL,
		house_num INT NOT NULL,
		city VARCHAR(100) NOT NULL,
		psc INT NOT NULL);


DROP TABLE IF EXISTS customers CASCADE;
	
CREATE TABLE customers 
	(customer_id INT PRIMARY KEY,
	name	 VARCHAR(100) NOT NULL,
	adress_id INT,
	FOREIGN KEY (adress_id) REFERENCES adresses(adress_id) ON UPDATE CASCADE ON DELETE SET NULL);


DROP TABLE IF EXISTS orders CASCADE;;
	
CREATE TABLE orders 
	(order_id INT PRIMARY KEY,
	customer_id INT,
	date DATE,
	completed BOOLEAN,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON UPDATE CASCADE ON DELETE CASCADE);




DROP TABLE IF EXISTS goods CASCADE;

CREATE TABLE goods 
	(item_id INT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	price INT,
	available_quantity INT);


DROP TABLE IF EXISTS order_items CASCADE;

CREATE TABLE order_items
	(order_item_id INT PRIMARY KEY,
	item_id INT,
	quantity INT CHECK (quantity > 0),
	FOREIGN KEY (item_id) REFERENCES goods(item_id) ON UPDATE CASCADE ON DELETE CASCADE);



