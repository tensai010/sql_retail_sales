-- data exploration
-- how many sales we have?
select count(*) total_sales
from retail_sales;

-- how many customers we have?
select count(distinct customer_id) as total_customers
from retail_sales;

-- categories
select distinct category as categories
from retail_sales;


-- DATA ANALYSIS
-- 1) retrieve all columns for sales made on '2022-11-05'
select * 
	from retail_sales
		where sale_date = '2022-11-05';

-- 2) retrieve all transactions where the category is clothing and the quantity sold is more than 4 in the month of Nov-2022
select *
		from retail_sales
where 
		category= 'Clothing' 
		and to_char(sale_date, 'YYYY-MM')='2022-11' 
		and quantity >= 4;

--3) write a query to calculate the total sales for each category
select category , 
	sum(total_sales) as net_sales,
	count(*) as total_orders
		from retail_sales
		group by 1;

-- 4) write a query to find the average age of customers who purchased items from the beauty category
select 
	round (avg(age),2) as avg_age,
	category
from retail_sales
	where category = 'Beauty'
group by category;

--5) write a query to find all transactions where the total_sale is > 1000
select *
from retail_sales
where total_sales > 1000;

--6) write a query to find the total number of transactions made by each gender in each category
select 
	count(transactions_id) as total_transactions,
	gender,
	category 
from retail_sales
group by 
	gender,
	category
order by 1;

-- 7) write a query to calculate the average sale for each month. find out best selling month in each year
select 
	year,
	month,
	avg_sale 
from 
	(select 
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sales) as avg_sale,
		rank() over(partition by extract(year from sale_date) order by avg(total_sales)desc) as rank
	from retail_sales
	group by 1,2)
as a1
where rank=1;
--order by 1,3 desc

-- 8) write a query to find the top 5 customers based on the highest total sales
	
select
	customer_id,
	sum(total_sales) as total_sales
from retail_sales
group by customer_id
order by total_sales desc
limit 5;

-- 9) write a query to find out the number of unique customers who purchased items from each category
select
	count(distinct customer_id) no_of_customers,
	category
	from retail_sales
group by category;

-- 10) write a query to create each shift and numbner of orders 
with hourly_sale as
(select *,
	case
		when extract (hour from sale_time) < 12 then 'morning'
		when extract (hour from sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
	from retail_sales)
select  shift , count(*) as total_orders
from hourly_sale
group by shift
order by total_orders desc
