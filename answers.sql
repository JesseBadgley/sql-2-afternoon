--Practice Joins
--1
SELECT * FROM invoice i
JOIN invoice_line il ON il.invoice_id = i.invoice_id 
WHERE il.unit_price > 0.99;

--2
SELECT i.invoice_date, c.first_name, c.last_name, i.total
FROM invoice i JOIN customer c ON i.customer_id = c.customer_id;

--3
SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c JOIN employee e ON c.support_rep_id = e.employee_id;

--4
SELECT l.title, r.name
FROM album l JOIN artist r ON l.artist_id = r.artist_id;

--5
SELECT pt.track_id FROM playlist_track pt
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';

--6
SELECT t.name FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;

--7
SELECT t.name, p.name FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id;

--8
SELECT t.name, a.title FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';




--Practice Nested Queries
-- 1
SELECT * FROM invoice
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line 
WHERE unit_price > 0.99);
-- 2
SELECT * FROM playlist_track
WHERE playlist_id IN ( SELECT playlist_id FROM playlist WHERE name = 'Music');
-- 3
SELECT name FROM track 
WHERE track_id IN (SELECT track_id FROM playlist_track WHERE playlist_id = 5);
-- 4
SELECT * FROM track
WHERE genre_id IN ( SELECT genre_id FROM genre WHERE name = 'Comedy');
-- 5
SELECT * FROM track
WHERE album_id IN ( SELECT album_id FROM album WHERE title = 'Fireball');
-- 6
SELECT * FROM track 
WHERE album_id IN (
  SELECT album_id FROM album WHERE artist_id IN (
    SELECT artist_id FROM artist WHERE name = 'Queen'
    )
  );

--Practice Updating Rows
-- 1
UPDATE customer SET fax = null
WHERE fax IS NOT null;
-- 2
UPDATE customer SET company = 'Self'
WHERE company IS null;
-- 3
UPDATE customer SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett';
-- 4
UPDATE customer SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl';
-- 5
UPDATE track SET composer = 'The darkness around us'
WHERE genre_id = ( SELECT genre_id FROM genre WHERE name = 'Metal' )
AND composer IS null;
-- 6
Command R on mac.

--Group By
-- 1
SELECT COUNT(*), g.name
FROM track AS t
JOIN genre AS g
ON t.genre_id = g.genre_id
GROUP BY g.name;
-- 2
SELECT COUNT(*), g.name FROM track AS t
JOIN genre AS g ON g.genre_id = t.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;
-- 3
SELECT ar.name, COUNT(*) FROM album AS al
JOIN artist AS ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;

--Use Distinct
-- 1
SELECT DISTINCT composer FROM track;
-- 2
SELECT DISTINCT billing_postal_code FROM invoice;
-- 3
SELECT DISTINCT company FROM customer;

--Delete Rows
-- 1. Copy, paste, and run the SQL code from the summary.
-- 2
DELETE FROM practice_delete WHERE type = 'bronze';
-- 3
DELETE FROM practice_delete WHERE type = 'silver';
-- 4
DELETE FROM practice_delete WHERE value = 150;

--eCommmerce Simulation
-- 1
CREATE TABLE users
(id SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 email VARCHAR(100) NOT NULL
);

CREATE TABLE products
(id SERIAL PRIMARY KEY,
 name VARCHAR(100) NOT NULL,
 price INTEGER NOT NULL
);

CREATE TABLE orders
(id SERIAL PRIMARY KEY,
 product_id INTEGER,
 FOREIGN KEY (id) references products(id)
);

-- 2
INSERT INTO users 
(name, email)
VALUES 
('peter', 'peter@123.com'),
('paul', 'paul@123.com'),
('marry', 'marry@123.com');

INSERT INTO products 
(name, price)
VALUES 
('socks', 10),
('drugs', 50),
('cake', 100);

INSERT INTO orders
(product_id)
VALUES
(1), (2), (3);

-- 3. Run queries against your data.
    -- Get all products for the first order.
SELECT * FROM products AS p
INNER JOIN orders AS o
ON p.id = o.id
WHERE o.id = 1;

    -- Get all orders.
SELECT * FROM orders;

    -- Get the total cost of an order.
SELECT o.id, SUM(p.price)
FROM products AS p
INNER JOIN orders AS o 
ON p.id = o.id
WHERE o.id = 3
GROUP BY o.id;

-- 4
ALTER TABLE users
ADD COLUMN order_id INTEGER
REFERENCES orders(id);

-- 5
UPDATE users
SET order_id = 1
WHERE id = 1;

UPDATE users
SET order_id = 2
WHERE id = 2;

UPDATE users
SET order_id = 3
WHERE id = 3;

-- 6. Run queries against your data.
-- Get all orders for a user.
SELECT * FROM users AS u
INNER JOIN orders AS o
ON o.id = u.order_id
WHERE u.id = 3;

-- Get how many orders each user has.
SELECT COUNT(*) FROM users AS u
INNER JOIN orders AS o
ON o.id = u.order_id
WHERE u.id = 2;

--(Black Diamond)
SELECT o.id, SUM(p.price)
FROM products AS p
INNER JOIN orders AS o
ON p.id = o.id
GROUP BY o.id;
