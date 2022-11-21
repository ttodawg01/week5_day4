SELECT *
FROM customer c 
WHERE loyalty_member = TRUE;


--reset all loyalty to false

UPDATE customer 
SET loyalty_member = FALSE;

SELECT *
FROM customer c 
WHERE loyalty_member = TRUE;

-- create a procedure for customers who have spent >= $100 to loyalty members

--query to get the customers who have spent more then 100


UPDATE customer 
SET loyalty_member = TRUE 
WHERE customer_id IN (
	select customer_id
	FROM payment p 
	GROUP BY customer_id 
	HAVING sum(amount) >= 100
);


--put into a stored procedure
CREATE OR REPLACE PROCEDURE update_loyalty_status(loyalty_min NUMERIC(5, 2))
LANGUAGE plpgsql
AS $$
BEGIN 
		UPDATE customer 
	SET loyalty_member = TRUE 
	WHERE customer_id IN (
		select customer_id
		FROM payment p 
		GROUP BY customer_id 
		HAVING sum(amount) >= loyalty_min
);
END;
$$;

--execute a procedure use CALL 

CALL update_loyalty_status(100);

SELECT *
FROM customer c 
WHERE loyalty_member = TRUE;


--find a customer who is close to the min
SELECT customer_id, sum(amount)
FROM payment p 
WHERE customer_id = 264
GROUP BY customer_id ;

--push one of the customers over the threshold 
INSERT INTO payment(customer_id, staff_id, rental_id, amount, payment_date)
values(264, 1, 1, 5.99, '2022-10-20 13:54:40');


SELECT *
FROM customer c 
WHERE customer_id = '264';

--call the PROCEDURE 
CALL update_loyalty_status(100);




-- create a procedure to add rows to table

-- Create a procedure that takes in arguments
CREATE OR REPLACE PROCEDURE add_actor(
	first_name VARCHAR(50),
	last_name VARCHAR(50)
)
LANGUAGE plpgsql 
AS $$ 
BEGIN 
	INSERT INTO actor(first_name, last_name, last_update)
	VALUES(first_name, last_name, NOW());
END
$$

CALL add_actor('mark', 'walberg');

SELECT *
FROM actor a
WHERE last_name = 'walberg';


--TO DELETE a PROCEDURE use DROP 

drop TABLE add_actor;
