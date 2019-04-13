-- Instruction 1a
use sakila;

SELECT
first_name,
last_name
FROM actor
;

-- Instruction 1b
SELECT
first_name,
last_name,
CONCAT (first_name,' ',last_name) AS Actor_Name
FROM actor
;

-- Instruction 2a
SELECT
actor_id,
first_name,
last_name
FROM actor
WHERE first_name = 'Joe'
;

-- Instruction 2b
SELECT
actor_id,
last_name
FROM actor
WHERE last_name LIKE '%GEN%'
;

-- Instruction 2c
SELECT
last_name,
first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC
;

-- Instruction 2d
SELECT 
country_id,
country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh','China')
;

-- Instruction 3a
ALTER TABLE actor
ADD COLUMN description BLOB
;
SELECT * FROM actor
;

-- Instruction 3b
ALTER TABLE actor
DROP COLUMN description
;

-- Instruction 4a
SELECT
last_name,
COUNT(*) AS last_name_count
FROM actor
GROUP BY last_name
;

-- Instruction 4b
SELECT last_name,
COUNT(last_name) AS last_name_count
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 2
;

-- Instruction 4c
--- First, find the record
SELECT
actor_id,
first_name,
last_name
FROM actor
WHERE first_name = 'GROUCHO'
;
--- Second, Fix the record
UPDATE actor
SET first_name = 'HARPO'
WHERE actor_id = 172
;
--- Third, verified the change
SELECT * FROM actor
WHERE actor_id = 172
;

-- Instruction 4d
UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id = 172
;

-- Instruction 5a
SHOW CREATE TABLE address;
-- alternative to show create table
DESCRIBE address;

-- Instruction 6a
SELECT first_name,last_name,address
FROM staff a
JOIN address b
ON a.address_id = b.address_id
;

-- Instruction 6b
SELECT 
a.first_name,
a.last_name,
c.staff_id,
SUM(c.amount)
FROM staff a
JOIN payment c
ON a.staff_id = c.staff_id
GROUP BY staff_id
;

-- Instruction 6c
SELECT
f.title,
a.actor_id,
COUNT(a.actor_id)
FROM film_actor a
INNER JOIN film f
ON f.film_id = a.film_id
GROUP BY actor_id
;

-- Instruction 6d
SELECT
a.title,
COUNT(a.title)
FROM film a
JOIN inventory i
ON i.film_id = a.film_id
WHERE a.title = 'Hunchback Impossible'
GROUP BY title
;

-- Instruction 6e
SELECT
first_name,
last_name,
SUM(amount) AS 'Total Amount Paid'
FROM customer c
JOIN payment p ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY last_name ASC
;

-- Instruction 7a
SELECT
f.title,
l.name
FROM film f
JOIN language l ON f.language_id = l.language_id
WHERE l.name = "English"
AND (f.title LIKE 'K%'
OR f.title LIKE 'Q%')
;

-- Instruction 7b
SELECT
f.title,
a.first_name,
a.last_name,
a.actor_id
FROM
film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE f.title = 'Alone Trip'
;

-- Instruction 7c
SELECT
cu.first_name,
cu.last_name,
cu.email,
co.country
FROM
customer cu
JOIN address a ON a.address_id = cu.address_id
JOIN city ci ON ci.city_id = a.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada'
;

-- Instruction 7d
SELECT
f.title,
ca.name
FROM film f
JOIN film_category fa ON f.film_id = fa.film_id
JOIN category ca ON ca.category_id = fa.category_id
WHERE ca.name = 'family'
;

-- Instruction 7e
SELECT
re.rental_id,
fi.title,
COUNT(nv.film_id)
FROM rental re
JOIN payment pa ON re.rental_id = pa.rental_id
JOIN inventory nv ON re.inventory_id = nv.inventory_id
JOIN film fi ON nv.film_id = fi.film_id
GROUP BY nv.film_id
ORDER BY COUNT(nv.film_id) DESC
;

-- Instruction 7f
SELECT
s.store_id,
SUM(pa.amount) AS 'Total Sales'
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment pa ON st.staff_id = pa.staff_id
JOIN address ad ON ad.address_id = s.address_id
GROUP BY s.store_id
;

-- Instruction 7g
SELECT 
s.store_id,
ci.city,
co.country
FROM store s
JOIN address a ON a.address_id = s.address_id
JOIN city ci ON ci.city_id = a.city_id
JOIN country co ON co.country_id = ci.country_id
;

--  Instruction 7h
SELECT
cat.category_id,
cat.name,
SUM(pay.amount) AS 'Gross Revenue'
FROM inventory inv
JOIN film_category fc ON inv.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN rental re ON re.inventory_id = inv.inventory_id
JOIN payment pay ON pay.rental_id = re.rental_id
GROUP BY(fc.category_id)
ORDER BY(SUM(pay.amount))DESC
LIMIT 5
;

-- Instruction 8a
CREATE VIEW `Top 5 Genres`
AS SELECT
cat.category_id,
cat.name,
SUM(pay.amount) AS 'Gross Revenue'
FROM inventory inv
JOIN film_category fc ON inv.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
JOIN rental re ON re.inventory_id = inv.inventory_id
JOIN payment pay ON pay.rental_id = re.rental_id
GROUP BY(fc.category_id)
ORDER BY(SUM(pay.amount))DESC
LIMIT 5
;

-- Instruction 8b
SHOW CREATE VIEW `Top 5 Genres`;

-- Instruction 8c
DROP VIEW `Top 5 Genres`;

