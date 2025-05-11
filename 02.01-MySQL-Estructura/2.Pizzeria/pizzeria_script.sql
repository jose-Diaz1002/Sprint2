CREATE DATABASE web_pizzeria;
USE web_pizzeria;

CREATE TABLE provinces(
	id_province INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45)
);

CREATE TABLE cities(
	id_city INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    id_province INT NOT NULL,
    FOREIGN KEY (id_province) REFERENCES provinces (id_province)
);

CREATE TABLE shops(
	id_shop INTEGER PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(60) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    id_city  INT NOT NULL,
    FOREIGN KEY (id_city) REFERENCES cities (id_city)
);

CREATE TABLE customers(
	id_customer INT(20)  PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    address VARCHAR(45) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
	id_city INT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_city) REFERENCES cities(id_city)
);

CREATE TABLE pizza_categories(
	id_category INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL 
);

CREATE TABLE products(
	id_product INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    description TEXT,
    image VARCHAR(300) NOT NULL,
    price DECIMAL(5,2) NOT NULL,
    type  ENUM('pizza', 'hamburguesa', 'bebida') NOT NULL,
    id_category INTEGER,
	FOREIGN KEY (id_category) REFERENCES pizza_categories (id_category)
);

CREATE TABLE employees(
	id_employee INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    last_name VARCHAR(45) NOT NULL,
    nif VARCHAR(25) NOT NULL,
    phone VARCHAR(25) NOT NULL,
    role ENUM ('Delivery','chef') NOT NULL,
    id_shop INT NOT NULL,
    FOREIGN KEY (id_shop)REFERENCES shops (id_shop)
);

CREATE TABLE orders(
	id_order INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_customer INT  NOT NULL,
	id_shop INT NOT NULL,
    date_and_time DATETIME NOT NULL,
	order_type ENUM ('Delivery','in shop') NOT NULL,
    price DECIMAL (6,2) NOT NULL,
	id_delivery INT,
    delivery_date DATETIME,
    FOREIGN KEY (id_customer) REFERENCES customers (id_customer),
	FOREIGN KEY (id_shop) REFERENCES shops (id_shop),
	FOREIGN KEY (id_delivery) REFERENCES employees (id_employee)
);

CREATE TABLE products_orders(
	id_order INT NOT NULL,
    id_product INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (id_order, id_product),
    FOREIGN KEY (id_order) REFERENCES orders(id_order),
    FOREIGN KEY (id_product) REFERENCES products(id_product)
);

INSERT INTO provinces (name) VALUES ('Madrid'), ('Barcelona');

-- Ciudades
INSERT INTO cities (name, id_province) VALUES 
('Madrid Capital', 1), 
('Móstoles', 1), 
('Barcelona Capital', 2);

-- Tiendas
INSERT INTO shops (address, postal_code, id_city) VALUES 
('Calle Gran Vía, 1', '28013', 1),
('Calle Mayor, 45', '28931', 2);

-- Clientes
INSERT INTO customers (name, last_name, address, postal_code, id_city, phone) VALUES 
('Ana', 'García', 'Calle Sol, 10', '28015', 1, '612345678'),
('Luis', 'Pérez', 'Calle Luna, 22', '28931', 2, '623456789');

-- Categorías de Pizzas
INSERT INTO pizza_categories (name) VALUES ('Clásicas'), ('Especiales');

-- Productos
INSERT INTO products (name, description, image, price, type, id_category) VALUES 
('Pizza Margarita', 'Pizza clásica con tomate y queso', 'margarita.jpg', 8.50, 'pizza', 1),
('Pizza Pepperoni', 'Pizza de pepperoni', 'pepperoni.jpg', 9.50, 'pizza', 2),
('Hamburguesa Clásica', 'Hamburguesa de ternera', 'hamburguesa.jpg', 7.00, 'hamburguesa', NULL),
('Coca-Cola', 'Bebida refrescante', 'cocacola.jpg', 2.00, 'bebida', NULL),
('Agua Mineral', 'Agua embotellada', 'agua.jpg', 1.50, 'bebida', NULL);

-- Empleados
INSERT INTO employees (name, last_name, nif, phone, role, id_shop) VALUES 
('Carlos', 'Sánchez', '12345678A', '634567890', 'Chef', 1),
('Marta', 'López', '87654321B', '645678901', 'Delivery', 1);

-- Pedidos
INSERT INTO orders (id_customer, id_shop, date_and_time, order_type, price, id_delivery, delivery_date) VALUES 
(1, 1, '2024-04-25 13:00:00', 'Delivery', 12.50, 2, '2024-04-25 13:45:00'),
(2, 1, '2024-04-26 14:00:00', 'In shop', 19.00, NULL, NULL);

-- Productos en pedidos
INSERT INTO products_orders (id_order, id_product, quantity) VALUES 
(1, 1, 1), -- Pedido 1: 1 Pizza Margarita
(1, 4, 1), -- Pedido 1: 1 Coca-Cola
(2, 2, 1), -- Pedido 2: 1 Pizza Pepperoni
(2, 5, 2); -- Pedido 2: 2 Aguas Minerale

-- CONSULTAS
-- Lista cuántos productos de categoría 'Bebidas' se han vendido en una determinada localidad.

SELECT c.name AS localidad, 
       SUM(po.quantity) AS total_bebidas_vendidas
FROM products_orders po
JOIN products p ON po.id_product = p.id_product
JOIN orders o ON po.id_order = o.id_order
JOIN customers cu ON o.id_customer = cu.id_customer
JOIN cities c ON cu.id_city = c.id_city
WHERE p.type = 'bebida' 
  AND c.name = 'Madrid Capital'
GROUP BY c.name;

-- Lista cuántos pedidos ha efectuado un determinado empleado/a.

SELECT e.name, e.last_name, COUNT(o.id_order) AS total_pedidos_entregados
FROM orders o
JOIN employees e ON o.id_delivery = e.id_employee
WHERE e.name = 'Marta' AND e.last_name = 'López'
GROUP BY e.id_employee;






























