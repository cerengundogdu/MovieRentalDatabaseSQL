### Project Overview

This project is a part of Udacity Nanodegree in Programming for Data Science with Python. The main objective of the project is to write effective queries to answer some business questions regarding the Sakila DVD Rental database. The project submitted in April, 2020.


The Sakila Database holds information about a company that rents movie DVDs. For this project, I queryed the database to gain an understanding of the customer base, such as what the patterns in movie watching are across different customer groups, how they compare on payment earnings, and how the stores compare in their performance. 

In this project, I exerted joins, subqueries and Common Table Expressions (CTE), aggregations and window statements.  


### Business Questions

- We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music. Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.
(*) Provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:
	- Category
	- Rental length category
	- Count 
- We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?
- For each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.


