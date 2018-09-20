# Homework Assignment
# Alex Barrera
## Installation Instructions

* Refer to the [installation guide](Installation.md) to install the necessary files.

## Instructions
use sakila;
* 1a. Display the first and last names of all actors from the table `actor`.
select * from actor limit 100;

select first_name, last_name from actor;
* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.

select upper(concat(first_name,' ', last_name)) as `Actor Name` from actor;

* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

select actor_id, first_name, last_name from actor 
where first_name = 'Joe';

* 2b. Find all actors whose last name contain the letters `GEN`:

select * from actor where last_name regexp'GEN';

* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:

select * from actor where last_name regexp'LI'
order by last_name, first_name;

* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 

select * from country limit 100;

select country_id, country from country where 
country in ('Afghanistan', 'Bangladesh', 'China');



* 3a. You want to keep a description of each actor. You dont think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor 
ADD COLUMN description BLOB;

* 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

ALTER TABLE actor 
DROP COLUMN description;

* 4a. List the last names of actors, as well as how many actors have that last name.

select last_name, count(*) 
from actor
group by last_name
order by count(*) desc;

* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(*) 
from actor
group by last_name
having count(*) > 1
order by count(*) desc;




* 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

UPDATE actor
set first_name = 'HARPO' 
where first_name = 'GROUCHO'
and last_name = 'WILLIAMS';


* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

UPDATE actor
set first_name = 'GROUCHO' 
where first_name = 'HARPO';

* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

describe address;

show create table address; 


  * Hint: <https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html>

* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

select s.first_name, s.last_name, a.address from staff s join address a
on s.address_id = a.address_id;


* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

select s.first_name, s.last_name, p.staff_id, sum(p.amount)
from staff s join payment p 
on s.staff_id = p.staff_id 
where year(p.payment_date) = '2005' 
and month(p.payment_date) = '8'
group by p.staff_id;

* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

select f.title, count(*)
from film f join film_actor a
on f.film_id = a.film_id
group by f.title
order by count(*) desc;



* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

One 

select * from film 
where title regexp'Hunchback Impossible';

* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

select c.first_name, c.last_name, c.customer_id, sum(p.amount) as 'total_paid'
from customer c join payment p 
on c.customer_id = p.customer_id
group by c.customer_id
order by c.last_name;


  ```
  	![Total amount paid](Images/total_payment.png)
  ```

* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

select f.title 
from film f join language l 
on f.language_id = l.language_id
where f.title like'K%' or f.title like 'Q%'
and f.language_id=1;


* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

select * from actor act 
where act.actor_id in 
(
select a.actor_id from film_actor a 
where a.film_id in 
(
select f.film_id from film f where title='Alone Trip'
)
);

* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select * from customer c join address a 
on c.address_id = a.address_id 
join  city cty 
on a.city_id = cty.city_id
join country co 
on cty.country_id = co.country_id 
where co.country='Canada';

* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select f.* from film f  join film_category fc 
on f.film_id = fc.film_id 
join category c 
on fc.category_id = c.category_id 
and c.name = 'Family';

* 7e. Display the most frequently rented movies in descending order.

select f.title, count(*)  from 
film f join inventory i 
on f.film_id = i.film_id 
join rental r on r.inventory_id = i.inventory_id 
group by f.title
order by count(*) desc;


* 7f. Write a query to display how much business, in dollars, each store brought in.

select s.store_id, sum(p.amount) as totalbusiness
from store s join inventory i 
on s.store_id = i.store_id 
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by  s.store_id 
order by sum(p.amount) desc;



* 7g. Write a query to display for each store its store ID, city, and country.

select s.store_id, c.city, cn.country from store s 
join address a on s.address_id = a.address_id 
join city c on a.city_id = c.city_id 
join country cn on c.country_id = cn.country_id;



* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select c.category_id, c.name, sum(p.amount) as revenue
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id 
join payment p on p.rental_id = r.rental_id
group by c.category_id, c.name
order by sum(p.amount) desc
limit 5;

* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you havent solved 7h, you can substitute another query to create a view.

CREATE VIEW top5genres AS 
select c.category_id, c.name, sum(p.amount) as revenue
from category c
join film_category fc on c.category_id = fc.category_id
join inventory i on fc.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id 
join payment p on p.rental_id = r.rental_id
group by c.category_id, c.name
order by sum(p.amount) desc
limit 5;

* 8b. How would you display the view that you created in 8a?

select * from top5genres;

* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.

 drop view top5genres;

## Appendix: List of Tables in the Sakila DB

* A schema is also available as `sakila_schema.svg`. Open it with a browser to view.

```sql
	'actor'
	'actor_info'
	'address'
	'category'
	'city'
	'country'
	'customer'
	'customer_list'
	'film'
	'film_actor'
	'film_category'
	'film_list'
	'film_text'
	'inventory'
	'language'
	'nicer_but_slower_film_list'
	'payment'
	'rental'
	'sales_by_film_category'
	'sales_by_store'
	'staff'
	'staff_list'
	'store'
```

## Uploading Homework

* To submit this homework using BootCampSpot:

  * Create a GitHub repository.
  * Upload your .sql file with the completed queries.
  * Submit a link to your GitHub repo through BootCampSpot.
