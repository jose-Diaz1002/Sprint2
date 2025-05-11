CREATE DATABASE culo_de_botella;
USE culo_de_botella;

CREATE TABLE addresses(
	id_address INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    street VARCHAR(45) NOT NULL,
    number VARCHAR(45) NOT NULL,
    floor VARCHAR(45) NOT NULL,
    door VARCHAR(45) NOT NULL,
    postal_code VARCHAR(45) NOT NULL,
    city VARCHAR(45) NOT NULL,
    country VARCHAR(45) NOT NULL
);

CREATE TABLE suppliers(
	id_supplier INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    id_address INT NOT NULL,
    phone VARCHAR(45) NOT NULL,
    fax VARCHAR(45),
    NIF VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_address) REFERENCES addresses (id_address)
);

CREATE TABLE glasses(
	id_glasses INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_supplier INTEGER NOT NULL,
    brand VARCHAR(45) NOT NULL,
	right_lens_prescription DECIMAL(4,2) NOT NULL,  
	left_lens_prescription DECIMAL(4,2) NOT NULL,
	type_of_frame ENUM('floating', 'plastic', 'metal') NOT NULL,
	frame_color VARCHAR(45) NOT NULL, 
	right_crystal_color VARCHAR(45) NOT NULL,
    left_crystal_color VARCHAR(45) NOT NULL,
	price DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (id_supplier) REFERENCES suppliers (id_supplier)
);

CREATE TABLE employees(
	id_employee INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    id_address INTEGER NOT NULL,
    FOREIGN KEY (id_address) REFERENCES addresses (id_address)
);

CREATE TABLE customers(
	id_customer INTEGER PRIMARY KEY  AUTO_INCREMENT,
    id_registration INTEGER NOT NULL
);

CREATE TABLE customer_registration (
	id_registration INTEGER PRIMARY KEY AUTO_INCREMENT,
    date_registration DATETIME NOT NULL,
    name VARCHAR(45) NOT NULL,
    id_address INT NOT NULL,
    phone VARCHAR(45) NOT NULL,
    mail VARCHAR(45) NOT NULL,
    referred_by  INTEGER, 
    FOREIGN KEY (id_address) REFERENCES addresses (id_address),
    FOREIGN KEY (referred_by ) REFERENCES customers (id_customer)
);

ALTER TABLE customers 
ADD CONSTRAINT fk_customer_registration
FOREIGN KEY (id_registration) REFERENCES customer_registration (id_registration);

CREATE TABLE sales(
	id_sales INTEGER PRIMARY KEY AUTO_INCREMENT,    
    id_customer INTEGER,
	id_employee INTEGER NOT NULL,
    id_glasses INTEGER NOT NULL,
    sale_date DATETIME NOT NULL,
    FOREIGN KEY (id_customer) REFERENCES customers (id_customer),
    FOREIGN KEY (id_employee) REFERENCES employees (id_employee),
    FOREIGN KEY (id_glasses) REFERENCES glasses (id_glasses)
);

INSERT INTO addresses (id_address, street, city, postal_code, name, number, floor, door, country) 
VALUES 
(1, 'Street 123', 'New York', '10001', 'Home', '123', '1', 'A', 'USA'),
(2, 'Avenue 456', 'Los Angeles', '90001', 'Office', '456', '2', 'B', 'USA'),
(3, 'Third Blvd 789', 'Chicago', '60601', 'Apartment', '789', '3', 'C', 'USA'),
(4, 'Street 987', 'Miami', '08922', 'Condo', '987', '4', 'D', 'USA');

INSERT INTO customer_registration (id_registration, date_registration, name, id_address, phone, mail, referred_by) VALUES
(1, '2024-01-10 10:00:00', 'John Doe', 1, '123456789', 'john@example.com', NULL),
(2, '2024-02-15 15:30:00', 'Jane Smith', 2, '987654321', 'jane@example.com', NULL);

INSERT INTO customers (id_customer, id_registration) VALUES
(1, 1),
(2, 2);

INSERT INTO employees (id_employee, name, id_address) VALUES
(1, 'Mike Johnson', 1),
(2, 'Sara Parker', 2);

INSERT INTO suppliers (id_supplier, name, id_address, phone, fax, NIF) VALUES
(1, 'OpticWorld', 1, '111222333', '111222334', 'NIF123'),
(2, 'VisionPlus', 2, '444555666', NULL, 'NIF456');

INSERT INTO glasses (id_glasses, id_supplier, brand, right_lens_prescription, left_lens_prescription, type_of_frame, frame_color, right_crystal_color, left_crystal_color, price) VALUES
(1, 1, 'Ray-Ban', 1.25, 1.00, 'plastic', 'black', 'transparent', 'transparent', 150.00),
(2, 2, 'Oakley', 0.75, 0.50, 'metal', 'silver', 'blue', 'blue', 200.00),
(3, 1, 'Gucci', 1.50, 1.25, 'floating', 'gold', 'green', 'green', 300.00);

-- DELETE FROM glasses;

INSERT INTO sales (id_sales, id_customer, id_employee, id_glasses, sale_date) VALUES
(1, 1, 1, 1, '2024-03-10 12:00:00'),
(2, 2, 2, 2, '2024-03-15 16:00:00'),
(3, 1, 2, 3, '2024-04-05 11:00:00');

SELECT COUNT(*) AS total_facturas
FROM sales
WHERE id_customer = 3
  AND sale_date BETWEEN '2024-01-01' AND '2024-12-31';
  
  SELECT DISTINCT g.brand
FROM sales s
JOIN glasses g ON s.id_glasses = g.id_glasses
WHERE s.id_employee = 2
  AND YEAR(s.sale_date) = 2024;
  
  SELECT DISTINCT sup.name
FROM sales s
JOIN glasses g ON s.id_glasses = g.id_glasses
JOIN suppliers sup ON g.id_supplier = sup.id_supplier;









































