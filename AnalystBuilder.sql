
--------------------------------------------- ANALYST BUILDER ---------------------------------------------------------------------

--Q1 I love chocolate and only want delicious baked goods that have chocolate in them! 
--Write a Query to return bakery items that contain the word "Chocolate".

select product_name 
from products
where product_name like '%chocolate%'

--Q2. After about 10,000 miles, Electric bike batteries begin to degrade and need to be replaced. Write a query to determine 
--the amount of bikes that currently need to be replaced.

select sum(t) from(
select count(bike_id) as t 
from bikes
where miles>10000
group by bike_id
)m

--Q3. Often when you're working with customer information you'll want to sell that data to a third party. Sometimes it is 
--illegal to give away sensitive information such as a full name. Here you are given a table that contains a customer ID 
--and their full name. Return the customer ID with only the first name of each customer.

SELECT 
    [customer_id],
    CASE 
        WHEN CHARINDEX(' ', [full_name]) > 0
        THEN SUBSTRING([full_name], 1, CHARINDEX(' ', [full_name]) - 1)
        ELSE [full_name]
    END AS [first_name]
FROM 
    [customers];

--Q4. Costco is known for their rotisserie chickens they sell, not just because they are delicious, but because they are a 
--loss leader in this area. This means they actually lose money in selling the chickens, but they are okay with this because 
--they make up for that in other areas. Using the sales table, calculate how much money they have lost on their rotisserie 
--chickens this year. Round to the nearest whole number.

select 
     cast(sum(lost_revenue_millions) as decimal(10,0)) 
from sales

--Q5. Write a query that returns all of the stores whose average yearly revenue is greater than one million dollars.
--Output the store ID and average revenue. Round the average to 2 decimal places. Order by store ID.

select 
      store_id,
	  cast(avg(cast(revenue as float)) as decimal(10,2)) as avg_yearly_revenue 
from stores
group by store_id
having avg(revenue)>1000000

--Q6. Data was input incorrectly into the database. The ID was combined with the First Name. Write a query to separate the ID 
--and First Name into two separate columns.Each ID is 5 characters long.

select 
      substring(id,1,5) as id, 
	  substring(id,6,len(id)) as First_Name
from  bad_data

--Q7.Write a query to report the IDs of low quality YouTube videos. A video is considered low quality if the like 
--percentage of the video (number of likes divided by the total number of votes) is less than 55%. Return the result table ordered 
--by ID in ascending order.

select 
      video_id 
from youtube_videos
where cast(thumbs_up as decimal)/(thumbs_up+thumbs_down)<0.55
order by video_id asc

--Q8. Tesla just provided their quarterly sales for their major vehicles. Determine which Tesla Model has made the most profit.
--Include all columns with the "profit" column at the end.

select top 1 * from (
select *, (cast(car_price as decimal(18,2))-cast(production_cost as decimal(18,2)))*cast(cars_sold as decimal(18,2)) as profit from tesla_models
)t
order by profit desc 

--Q9. If our company hits its yearly targets, every employee receives a salary increase depending on what level you are in the 
--company. Give each Employee who is a level 1 a 10% increase, level 2 a 15% increase, and level 3 a 200% increase.
--Include this new column in your output as "new_salary" along with your other columns.

select *,
CASE
when pay_level=1 then (salary*(0.1))+salary 
when pay_level=2 then (salary*(0.15))+salary
when pay_level=3 then (salary*(2))+salary
end as new_salary
from employees

--Q10. Marcie's Bakery is having a contest at her store. Whichever dessert sells more each day will be on discount tomorrow. 
--She needs to identify which dessert is selling more. Write a query to report the difference between the number of Cakes and 
--Pies sold each day. Output should include the date sold, the difference between cakes and pies, and which one sold more 
--(cake or pie). The difference should be a positive number. Return the result table ordered by Date_Sold.

select date_sold, 
abs(sum(case when product='cake' then amount_sold else 0 end)-sum(case when product='pie' then amount_sold else 0 end )) ,
CASE
when sum(case when product='cake' then amount_sold else 0 end)>sum(case when product='pie' then amount_sold else 0 end)
then 'Cake' 
else 'Pie'
end as sold_more 
from desserts
group by date_sold

--Q11.Sarah's Bike Shop sells a lot of bikes and wants to know what the average sale price is of her bikes.
--She sometimes gives away a bike for free for a charity event and if she does she leaves the price of the bike as blank, 
--but marks it sold. Write a query to show her the average sale price of bikes for only bikes that were sold, and not donated.
--Round answer to 2 decimal places.

select 
      cast(avg(bike_price) as decimal(10,2)) 
from inventory
where bike_sold='Y'

--Q12. If a customer is 55 or above they qualify for the senior citizen discount. Check which customers qualify.
--Assume the current date 1/1/2023.
--Return all of the Customer IDs who qualify for the senior citizen discount in ascending order.

select 
      customer_id 
from customers
where datediff(year,birth_date,'01-01-2023')-1>=55
order by customer_id

--Q13. Write a query to find all dates with higher temperatures compared to the previous dates (yesterday).
--Order dates in ascending order.

with cte as(
select date, lead(date) over (order by date) as d, temperature,
lead(temperature) over (order by date) as temp from temperatures
)
select d from cte 
where temp>temperature
order by d

--Q14. Write a query to find the percentage of customers who shop at Kroger's who also have a Kroger's membership card.
--Round to 2 decimal places.
select 
      cast(cast(count(case when has_member_card='Y' then 1 end) as float)*100.0/count(distinct kroger_id) as decimal(10,2))
      as percentage 
from customers

--Q15.In the United States, fast food is the cornerstone of it's very society. Without it, it would cease to exist.
--But which region spends the most money on fast food?
--Write a query to determine which region spends the most amount of money on fast food.

select top 1 region from(
select region, sum(fast_food_millions) as t from food_regions
group by region 
)m  
order by t desc

--Q16.Cars need to be inspected every year in order to pass inspection and be street legal. 
--If a car has any critical issues it will fail inspection or if it has more than 3 minor issues it will also fail.
--Write a query to identify all of the cars that passed inspection.
--Output should include the owner name and vehicle name. Order by the owner name alphabetically.

select 
      owner_name, 
	  vehicle 
from inspections
where critical_issues=0 and minor_issues<=3
order by owner_name

--Q17. Yan is a sandwich enthusiast and is determined to try every combination of sandwich possible. He wants to start
--with every combination of bread and meats and then move on from there, but he wants to do it in a systematic way.
--Below we have 2 tables, bread and meats
--Output every possible combination of bread and meats to help Yan in his endeavors.
--Order by the bread and then meat alphabetically. This is what Yan prefers.

select 
      bread_name, 
	  meat_name 
from bread_table,meat_table
order by bread_name, meat_name

--Q18. At Kelly's Ice Cream Shop, Kelly gives a 33% discount on each customer's 3rd purchase.
--Write a query to select the 3rd transaction for each customer that received that discount. 
--Output the customer id, transaction id, amount, and the amount after the discount as "discounted_amount".
--Order output on customer ID in ascending order.
--Note: Transaction IDs occur sequentially. The lowest transaction ID is the earliest ID.

with cte as(
select customer_id, transaction_id, 
dense_rank() over (partition by customer_id order by transaction_id) as t, amount from purchases
)
select customer_id, transaction_id , amount, (amount-(0.33*amount)) as discounted_amount from cte
where t=3

--Q19. Tech companies have been laying off employees after a large surge of hires in the past few years.
--Write a query to determine the percentage of employees that were laid off from each company.
--Output should include the company and the percentage (to 2 decimal places) of laid off employees. 
--Order by company name alphabetically.

select 
      company, 
	  round(cast(employees_fired*100.0 as float)/company_size, 2) as percentage_laid_off 
from tech_layoffs
order by company

--Q20. Return all the candidate IDs that have problem solving skills, SQL experience, knows Python or R, and has domain knowledge.
--Order output on IDs from smallest to largest.

select 
      candidate_id 
from candidates
where problem_solving is not null and sql_experience is not null and
domain_knowledge is not null and (python is not null or r_programming is not null)

--Q21.Write a query to determine the popularity of a post on LinkedIn
--Popularity is defined by number of actions (likes, comments, shares, etc.) divided by the number impressions the post 
--received * 100. If the post receives a score higher than 1 it was very popular.
--Return all the post IDs and their popularity where the score is 1 or greater. Order popularity from highest to lowest.

select
      post_id, 
	  popularity from 
	  (
       select 
	         post_id, 
			 round(cast(sum(actions)*100.0 as float)/sum(impressions) , 4) as popularity 
	   from linkedin_posts
       group by post_id
      )T 
where popularity>=1
order by popularity desc




































                                                                                                                                                                                             















