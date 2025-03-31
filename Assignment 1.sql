-- SQL Basics

-- 1. Create a table called employees with constraints
CREATE TABLE employees (
    emp_id INT PRIMARY KEY NOT NULL,
    emp_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10,2) DEFAULT 30000
);

-- 2. Purpose of constraints and examples
-- Constraints ensure data integrity by enforcing rules. Examples:
-- NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK, DEFAULT.

-- 3. Why use NOT NULL? Can primary key be NULL?
-- NOT NULL ensures mandatory data. Primary keys CANNOT be NULL by definition.

-- 4. Add/Remove constraints example
-- Add: ALTER TABLE employees ADD CONSTRAINT chk_salary CHECK (salary > 0);
-- Remove: ALTER TABLE employees DROP CONSTRAINT chk_salary;

-- 5. Constraint violation example
-- Attempt to insert duplicate email:
-- INSERT INTO employees (emp_id, emp_name, age, email) VALUES (1, 'John', 25, 'john@example.com');
-- Error: Violation of UNIQUE KEY constraint.

-- 6. Alter products table to add constraints
ALTER TABLE products
ADD CONSTRAINT pk_product_id PRIMARY KEY (product_id);

ALTER TABLE products
ADD CONSTRAINT df_price DEFAULT 50.00 FOR price;

-- 7. INNER JOIN students and classes
SELECT student_name, class_name
FROM students
INNER JOIN classes ON students.class_id = classes.class_id;

-- 8. INNER and LEFT JOIN for orders
SELECT o.order_id, c.customer_name, p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN customers c ON o.customer_id = c.customer_id;

-- 9. Total sales amount per product
SELECT p.product_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name;

-- 10. Quantity ordered by each customer
SELECT o.order_id, c.customer_name, oi.quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id;

-- SQL Commands on Maven Movies DB

-- 1. Identify PK and FK
-- Example: film.actor_id is PK, film.actor_id in film_actor is FK

-- 2. List all actors
SELECT * FROM actor;

-- 3. List all customer info
SELECT * FROM customer;

-- 4. List different countries
SELECT DISTINCT country FROM country;

-- 5. Display active customers
SELECT * FROM customer WHERE active = 1;

-- 6. Rental IDs for customer 1
SELECT rental_id FROM rental WHERE customer_id = 1;

-- 7. Films with rental duration > 5
SELECT * FROM film WHERE rental_duration > 5;

-- 8. Total films with replacement cost between $15-$20
SELECT COUNT(*) FROM film WHERE replacement_cost BETWEEN 15 AND 20;

-- 9. Unique first names of actors
SELECT COUNT(DISTINCT first_name) FROM actor;

-- 10. First 10 customers
SELECT TOP 10 * FROM customer;

-- 11. First 3 customers with name starting with 'b'
SELECT TOP 3 * FROM customer WHERE first_name LIKE 'b%';

-- 12. First 5 G-rated movies
SELECT TOP 5 title FROM film WHERE rating = 'G';

-- 13. Customers with name starting with 'a'
SELECT * FROM customer WHERE first_name LIKE 'a%';

-- 14. Customers with name ending with 'a'
SELECT * FROM customer WHERE first_name LIKE '%a';

-- 15. First 4 cities starting and ending with 'a'
SELECT TOP 4 city FROM city WHERE city LIKE 'a%a';

-- 16. Customers with 'NI' in name
SELECT * FROM customer WHERE first_name LIKE '%NI%';

-- 17. 'r' in second position
SELECT * FROM customer WHERE first_name LIKE '_r%';

-- 18. Name starts with 'a' and at least 5 chars
SELECT * FROM customer WHERE first_name LIKE 'a%' AND LEN(first_name) >= 5;

-- 19. Name starts with 'a' and ends with 'o'
SELECT * FROM customer WHERE first_name LIKE 'a%o';

-- 20. Films with PG and PG-13
SELECT * FROM film WHERE rating IN ('PG', 'PG-13');

-- 21. Film length between 50 and 100
SELECT * FROM film WHERE length BETWEEN 50 AND 100;

-- 22. Top 50 actors
SELECT TOP 50 * FROM actor;

-- 23. Distinct film IDs from inventory
SELECT DISTINCT film_id FROM inventory;

-- Functions - Aggregate
-- 1. Total rentals
SELECT COUNT(*) FROM rental;

-- 2. Avg rental duration
SELECT AVG(rental_duration) FROM film;

-- String Functions
-- 3. Uppercase customer names
SELECT UPPER(first_name), UPPER(last_name) FROM customer;

-- 4. Month from rental date
SELECT rental_id, MONTH(rental_date) AS rental_month FROM rental;

-- GROUP BY
-- 5. Rental count per customer
SELECT customer_id, COUNT(*) AS rental_count FROM rental GROUP BY customer_id;

-- 6. Revenue per store
SELECT store_id, SUM(amount) AS total_revenue FROM payment GROUP BY store_id;

-- 7. Rentals per category
SELECT c.name, COUNT(*) AS rental_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

-- 8. Avg rental rate per language
SELECT l.name, AVG(f.rental_rate) AS avg_rate
FROM language l
JOIN film f ON l.language_id = f.language_id
GROUP BY l.name;

-- Joins
-- 9. Film title and customer name
SELECT f.title, c.first_name, c.last_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id;

-- 10. Actors in "Gone with the Wind"
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

-- 11. Customer spending
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;

-- 12. Movies rented by city
SELECT ci.city, c.first_name, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London';

-- Advanced Joins
-- 13. Top 5 rented movies
SELECT f.title, COUNT(*) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

-- 14. Customers who rented from both stores
SELECT customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY customer_id
HAVING COUNT(DISTINCT i.store_id) = 2;

-- Window Functions
-- 1. Rank customers by spending
SELECT customer_id, SUM(amount) AS total_spent,
RANK() OVER (ORDER BY SUM(amount) DESC) AS rank
FROM payment
GROUP BY customer_id;

-- 2. Cumulative revenue per film
SELECT film_id, payment_date, SUM(amount)
OVER (PARTITION BY film_id ORDER BY payment_date) AS cumulative_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id;

-- 3. Avg rental duration per length group
SELECT film_id, length, rental_duration,
AVG(rental_duration) OVER (PARTITION BY length) AS avg_duration
FROM film;

-- 4. Top 3 films in each category by rental count
WITH FilmRentals AS (
    SELECT c.name AS category, f.title, COUNT(*) AS rental_count,
    RANK() OVER (PARTITION BY c.name ORDER BY COUNT(*) DESC) AS rank
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, f.title
)
SELECT * FROM FilmRentals WHERE rank <= 3;

-- 5. Rental difference from average
WITH RentalCounts AS (
    SELECT customer_id, COUNT(*) AS total_rentals FROM rental GROUP BY customer_id
),
AvgCount AS (
    SELECT AVG(total_rentals * 1.0) AS avg_rentals FROM RentalCounts
)
SELECT r.customer_id, r.total_rentals, a.avg_rentals, r.total_rentals - a.avg_rentals AS diff
FROM RentalCounts r, AvgCount a;

-- 6. Monthly revenue trend
SELECT MONTH(payment_date) AS month, YEAR(payment_date) AS year, SUM(amount) AS revenue
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date);

-- 7. Top 20% spenders
WITH CustomerSpending AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment GROUP BY customer_id
),
PercentileCutoff AS (
    SELECT PERCENTILE_CONT(0.80) WITHIN GROUP (ORDER BY total_spent) AS cutoff FROM CustomerSpending
)
SELECT cs.* FROM CustomerSpending cs
JOIN PercentileCutoff pc ON cs.total_spent >= pc.cutoff;

-- 8. Running total of rentals by category
WITH RentalCounts AS (
    SELECT c.name AS category, COUNT(*) AS rental_count
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name
)
SELECT *, SUM(rental_count) OVER (ORDER BY rental_count DESC) AS running_total
FROM RentalCounts;

-- 9. Films rented below average per category
WITH CatAvg AS (
    SELECT fc.category_id, AVG(cnt) AS avg_rentals
    FROM (
        SELECT fc.category_id, f.film_id, COUNT(*) AS cnt
        FROM film f
        JOIN film_category fc ON f.film_id = fc.film_id
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        GROUP BY fc.category_id, f.film_id
    ) x
    GROUP BY category_id
)
SELECT f.title, fc.category_id
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, fc.category_id
HAVING COUNT(*) < (SELECT avg_rentals FROM CatAvg WHERE category_id = fc.category_id);

-- 10. Top 5 revenue months
SELECT TOP 5 MONTH(payment_date) AS month, YEAR(payment_date) AS year, SUM(amount) AS revenue
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY revenue DESC;

-- Normalization & CTE
-- 1NF, 2NF, 3NF are theoretical. Example tables can be reviewed in Sakila DB.

-- CTE: Distinct actor names & film count
WITH ActorFilms AS (
    SELECT actor_id, COUNT(*) AS film_count
    FROM film_actor GROUP BY actor_id
)
SELECT a.first_name, a.last_name, af.film_count
FROM actor a JOIN ActorFilms af ON a.actor_id = af.actor_id;

-- CTE with film and language
WITH FilmLang AS (
    SELECT f.title, l.name AS language_name, f.rental_rate
    FROM film f JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM FilmLang;

-- CTE for customer revenue
WITH CustRevenue AS (
    SELECT customer_id, SUM(amount) AS revenue
    FROM payment GROUP BY customer_id
)
SELECT * FROM CustRevenue;

-- CTE with window function
WITH FilmRank AS (
    SELECT title, rental_duration,
    RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
    FROM film
)
SELECT * FROM FilmRank;

-- CTE filter customers with >2 rentals
WITH FrequentRenters AS (
    SELECT customer_id, COUNT(*) AS rentals FROM rental GROUP BY customer_id HAVING COUNT(*) > 2
)
SELECT c.* FROM customer c JOIN FrequentRenters fr ON c.customer_id = fr.customer_id;

-- CTE: Monthly rental count
WITH MonthlyRentals AS (
    SELECT YEAR(rental_date) AS yr, MONTH(rental_date) AS mo, COUNT(*) AS rental_count
    FROM rental GROUP BY YEAR(rental_date), MONTH(rental_date)
)
SELECT * FROM MonthlyRentals;

-- CTE Self-Join: Actors in same film
WITH ActorPairs AS (
    SELECT fa1.actor_id AS actor1, fa2.actor_id AS actor2, fa1.film_id
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
)
SELECT * FROM ActorPairs;

-- Recursive CTE: Employee hierarchy
WITH RecursiveStaff AS (
    SELECT staff_id, first_name, last_name, reports_to FROM staff WHERE staff_id = @ManagerID
    UNION ALL
    SELECT s.staff_id, s.first_name, s.last_name, s.reports_to
    FROM staff s
    JOIN RecursiveStaff rs ON s.reports_to = rs.staff_id
)
SELECT * FROM RecursiveStaff;
