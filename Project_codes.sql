/* Q1 */
/* SET 1 Q1. We want to understand more about the movies that families are watching.
The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.
Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out. */  

WITH t1 as (
			SELECT 
				f.film_id, 
				f.title as film_name, 
				c.name as category_name, 
				r.rental_id
			FROM film f
			JOIN film_category fc ON fc.film_id = f.film_id
			JOIN category c ON c.category_id = fc.category_id
			JOIN inventory i ON f.film_id=i.film_id
			JOIN rental r ON r.inventory_id = i.inventory_id
			WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
			)

SELECT 
		film_name, 
		category_name, 
		COUNT(*)
FROM t1
GROUP BY 1, 2
ORDER BY 2,1;

---- WITHOUT CTE ------

SELECT 
		f.title as film_name, 
		c.name as category_name, 
		COUNT(*)
FROM film f
JOIN film_category fc ON fc.film_id = f.film_id
JOIN category c ON c.category_id = fc.category_id
JOIN inventory i ON f.film_id=i.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1, 2
ORDER BY 2,1;



/* Q2 */
/* SET 1 Q3. Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count 
of movies within each combination of film category for each corresponding rental duration category. The resulting table should 
have three columns:
- Category
- Rental length category
- Count */


WITH t2 AS (SELECT f.title film_name, c.name category_name, 
	NTILE(4) OVER (ORDER BY rental_duration) AS quartile_duration 
	FROM category c 
	JOIN film_category fc ON c.category_id = fc.category_id 
	JOIN film f ON f.film_id = fc.film_id 
	WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))
SELECT 	category_name, 
		quartile_duration, 
		COUNT(*)
FROM t2
GROUP BY 1,2
ORDER BY 1,2;



/*Q3 */
/* SET 2 Q2. We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007,
and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, 
and total payment amount for each month by these top 10 paying customers? */

WITH t1 AS (
			SELECT 
				CONCAT(c.first_name, ' ', c.last_name) as customer_name,
		   		DATE_TRUNC('month', payment_date) as payment_month,
		  		DATE_PART('year', payment_date) as payment_year,
		   		COUNT(*) as num_of_payment,
		   		SUM(amount) as tot_amount_of_payment
			FROM payment p
			JOIN customer c ON p.customer_id = c.customer_id
			GROUP BY 2,1,3
			HAVING DATE_PART('year', payment_date) = 2007
			ORDER BY 1,2
			),

t2 AS 	(
		SELECT 
			CONCAT(c.first_name, ' ', c.last_name) as customer_name,
	   		SUM(amount) as tot_amount_of_payment
		FROM payment p
		JOIN customer c ON p.customer_id = c.customer_id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10
		)

SELECT t1.payment_month,
	   t1.customer_name,
	   t1.num_of_payment, 
	   t1.tot_amount_of_payment
FROM t1 
JOIN t2 ON t1.customer_name=t2.customer_name

/* Q4 */
/* SET 2 Q3. Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly
payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. 
Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name
who paid the most difference in terms of payments.*/

WITH t1 AS (
			SELECT 
				CONCAT(c.first_name, ' ', c.last_name) as customer_name,
	   			DATE_TRUNC('month', payment_date) as payment_month,
	   			DATE_PART('year', payment_date) as payment_year,
	   			SUM(amount) as tot_amount_of_payment
			FROM payment p
			JOIN customer c ON p.customer_id = c.customer_id
			GROUP BY 2,1,3
			HAVING DATE_PART('year', payment_date) = 2007
			ORDER BY 1,2),

t2 AS (
		SELECT 
			CONCAT(c.first_name, ' ', c.last_name) as customer_name,
			SUM(amount) as tot_amount_of_payment
		FROM payment p
		JOIN customer c ON p.customer_id = c.customer_id
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 10
	   )

SELECT t1.payment_month, 
	   t1.customer_name, 
	   t1.tot_amount_of_payment,
       LEAD(t1.tot_amount_of_payment) OVER (PARTITION BY t1.customer_name ORDER BY t1.payment_month) - t1.tot_amount_of_payment AS lead_difference
FROM t1 
JOIN t2 ON t1.customer_name=t2.customer_name