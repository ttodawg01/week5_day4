SELECT *
FROM actor ;

SELECT count(*)
FROM actor a 
WHERE last_name LIKE 'S%';


SELECT count(*)
FROM actor a 
WHERE last_name LIKE 'T%';


-- create a stores function that wil give us the count of actors with a last name that begins with 'letter'

$$'O''Brian' --O'Brian

CREATE OR REPLACE FUNCTION get_actor_count(letter varchar(1))
RETURNS integer 
LANGUAGE plpgsql
AS $$
	declare actor_count integer;
BEGIN 
	SELECT count(*) INTO actor_count
	FROM actor 
	WHERE last_name ILIKE concat(letter, '%');
	RETURN actor_count;
END;
$$;


-- execute the function we use SELECT 
SELECT get_actor_count('B');
SELECT get_actor_count('D');

SELECT get_actor_count('c');


--create a function that will return the employee with the most transactions based on payments

SELECT concat(first_name,' ', last_name) AS employee
FROM staff s 
WHERE staff_id = (
	SELECT staff_id
	FROM payment p
	GROUP BY staff_id 
	ORDER BY count(*) DESC 
	LIMIT 1
);

CREATE OR REPLACE FUNCTION employee_with_most_trans()
RETURNS varchar(90)
LANGUAGE plpgsql
AS $$
	DECLARE employee varchar(90);
BEGIN 
		SELECT concat(first_name,' ', last_name) into employee
	FROM staff s 
	WHERE staff_id = (
		SELECT staff_id
		FROM payment p
		GROUP BY staff_id 
		ORDER BY count(*) DESC 
		LIMIT 1
);
RETURN employee;
END ;
$$;

SELECT employee_with_most_trans();



--create a function that will return a table with customer info and
-- full address( address, district, city, state) BY country 

SELECT c.first_name, c.last_name , a.address , ci.city, a.district , co.country 
FROM customer c 
JOIN address a 
ON c.address_id = a.address_id 
JOIN city ci 
ON a.city_id = ci.city_id 
JOIN country co 
ON co.country_id = ci.country_id 
WHERE co.country = 'China';


CREATE OR REPLACE FUNCTION customers_in_country(country_name varchar(50))
RETURNS TABLE (
	first_name varchar(45),
	last_name varchar(45),
	address varchar(50),
	city varchar(50),
	district varchar(20),
	country varchar(50)
)
LANGUAGE plpgsql
AS $$
BEGIN 
	RETURN query 
	SELECT c.first_name, c.last_name , a.address , ci.city, a.district , co.country 
	FROM customer c 
	JOIN address a 
	ON c.address_id = a.address_id 
	JOIN city ci 
	ON a.city_id = ci.city_id 
	JOIN country co 
	ON co.country_id = ci.country_id 
	WHERE co.country = country_name;
END;
$$;

SELECT *
FROM customers_in_country('Mexico');

SELECT *
FROM customers_in_country('United States')
WHERE district = 'Illinois';

SELECT district, count(*)
FROM customers_in_country('Canada')
GROUP BY district;


--to delete a function use DROP
--DROP FUNCTION get_actor_count;


