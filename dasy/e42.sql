
INSERT INTO adresses(adress_id,street,house_num,city,psc) VALUES (1400,'2014 Jabberwocky Rd',26192,'Southlake', 768);
INSERT INTO adresses(adress_id,street,house_num,city,psc) VALUES (1500,'2014 Bubble Rd',243,'Boston', 942);
INSERT INTO adresses(adress_id,street,house_num,city,psc) VALUES (1600,'2014 SaintJabberwocky Rd',432,'New York', 942);

INSERT INTO customers(customer_id, name, adress_id) VALUES (45345, 'Mister SUmar', 1500);
INSERT INTO customers(customer_id, name, adress_id) VALUES (3545, 'HusSUmar', 1500);
INSERT INTO customers(customer_id, name, adress_id) VALUES (123, 'DUsek', 1400);


INSERT INTO orders(order_id, customer_id, date, completed) VALUES (324, 3545, '2018-10-20', TRUE);
INSERT INTO orders(order_id, customer_id, date, completed) VALUES (4324, 3545, '2018-4-7', FALSE);
INSERT INTO orders(order_id, customer_id, date, completed) VALUES (6324, 123, '2018-11-20', TRUE);



INSERT INTO goods(item_id, name, price, available_quantity) VALUES (724, 'table', 5000,45);
INSERT INTO goods(item_id, name, price, available_quantity) VALUES (624, 'spoon', 200,35);
INSERT INTO goods(item_id, name, price, available_quantity) VALUES (32, 'crown',999999,1);


INSERT INTO order_items(order_item_id, item_id, quantity ) VALUES (54532, 624,5);
INSERT INTO order_items(order_item_id, item_id, quantity ) VALUES (54345, 624,5);
INSERT INTO order_items(order_item_id, item_id, quantity) VALUES (59992, 724,15);
