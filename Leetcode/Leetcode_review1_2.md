**[626. Exchange Seats](https://zhuanlan.zhihu.com/p/259760085)** 

Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.
The column id is continuous increment.

> seat: id | student

Mary wants to change seats for the adjacent students. Can you write a SQL query to output the result for Mary? Note: If the number of students is odd, there is no need to change the last one's seat.

```
select 
case when id%2 = 1 and id not in (select max(id) from seat) then id + 1 # or use mod(id,2)=1
when id%2 = 0 then id - 1 else id end as id, student
from seat
order by 1
;
```

**[627. Swap Salary](https://zhuanlan.zhihu.com/p/259763823)** 

Given a table salary, such as the one below, that has m=male and f=female values.

> salary: id | name | sex | salary

Swap all f and m values (i.e., change all f values to m and vice versa) with a single update statement and no intermediate temp table.

Note that you must write a single update statement, DO NOT write any select statement for this problem.

```
update salary
set sex = case sex when 'f' then 'm' else 'f' end

#syntax: update tbl_name set var_old = (case var_old when val1 then val1_new else val2_new end);
;
```

**[1045. Customers Who Bought All Products](https://zhuanlan.zhihu.com/p/259932220)** 

> Customer: customer_id | product_key
> Product: product_key

Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

```
select customer_id
from Customer 
group by 1
having count(distinct product_key) = (select count(*) from product) # distinct product_key
;

select b.customer_id
from product a
left join customer b
on a.product_key = b.product_key
group by 1
having count(distinct b.product_key) = (select count(*) from product)
;

select distinct customer_id
from customer
where customer_id not in 
(select c.customer_id from product p left join customer c on p.product_key = c.product_key where c.customer_id is null)
;
```


**[1050. Actors & Directors Cooperated >= 3 Times](https://zhuanlan.zhihu.com/p/259934531)** 

Given a table salary, such as the one below, that has m=male and f=female values.

> salary: id | name | sex | salary

Swap all f and m values (i.e., change all f values to m and vice versa) with a single update statement and no intermediate temp table.

Note that you must write a single update statement, DO NOT write any select statement for this problem.

```
update salary
set sex = case sex when 'f' then 'm' else 'f' end

#syntax: update tbl_name set var_old = (case var_old when val1 then val1_new else val2_new end);
;
```


**[1068. Product Sales Analysis I](https://zhuanlan.zhihu.com/p/259935444)** 

(sale_id, year) is the primary key of this table.

product_id is a foreign key to Product table.

price is per/unit

> sales: sale_id | product_id | year | quantity | price

product_id is the primary key of this table

> product: product_id | product_name

Write an SQL query that reports all product names of the products in the Sales table along with their selling year and price.

```
select p.product_name, s.year, s.price
from sales s
left join product p
on s.product_id = p.product_id
;
```

**[1069. Product Sales Analysis II](https://zhuanlan.zhihu.com/p/259937061)** 

same table as 1068

Write an SQL query that reports the total quantity sold for every product id.

```
select product_id, sum(quantity) as total_quantity # no need for join tables; don't forget group by whenever you aggregate
from sales 
group by 1
;
```

**[1070. Product Sales Analysis III](https://zhuanlan.zhihu.com/p/259947312)** 

same table as 1068

Write an SQL query that selects the product id, year, quantity, and price for the first year of every product sold.

```
select product_id, year as first_year, quantity, price
from
(select *, rank() over(partition by product_id order by year asc) as year_rank
from sales) tmp
where year_rank = 1
;

# method 2
select s.product_id, s.year as first_year, s.quantity, s.price
from sales s
join (select product_id, min(year) as m_year from sales group by 1) tmp
on s.product_id = tmp.product_id and s.year = tmp.m_year
;
```

**[1075. Project Employees I](https://zhuanlan.zhihu.com/p/259948436)** 

(project_id, employee_id) is the primary key of this table.

employee_id is a foreign key to Employee table.

> project: project_id | employee_id

employee_id is the primary key of this table

> employee: employee_id | name | experience_years

Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

```
select p.project_id, round(avg(e.experience_years), 2) as average_years
from project p 
join employee e
on p.employee_id = e.employee_id
group by 1
;
```

**[1076. Project Employees II](https://zhuanlan.zhihu.com/p/259950260)** 

same table as 1075

Write an SQL query that reports all the projects that have the most employees.

```
with cte as (
select project_id, count(distinct employee_id) as cnt 
from project 
group by 1)

select project_id
from cte
where cnt = (select max(cnt) from cte)
;

select project_id
from project
group by 1
having count(employee_id) >= all(select count(employee_id) over(partition by project_id) from project)
;

select project_id
from 
(
select project_id, rank() over(order by count(employee_id) desc) as rk
from project
group by 1 # Server first executes the query and only then applies the windowed function as defined by you.
) tmp
where rk = 1
;
```

**[1077. Project Employees III](https://zhuanlan.zhihu.com/p/259952766)** 

same table as 1075

Write an SQL query that reports the most experienced employees in each project. In case of a tie, report all employees with the maximum number of experience years.

```
select project_id, employee_id
from
(select p.project_id, p.employee_id, rank() over(partition by p.project_id order by experience_years desc) as rk
from project p 
left join employee e
on p.employee_id = e.employee_id) tmp
where rk = 1
;
```

**[1082. Sales Analysis I](https://zhuanlan.zhihu.com/p/259957908)** 

product_id is the primary key of this table.

> product: product_id | product_name | unit_price

This table has no primary key, it can have repeated rows. product_id is a foreign key to Product table.

> sales: seller_id | product_id | buyer_id | sale_date | quantity | price

Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all.

```
with cte as (
select seller_id, rank() over(order by sum(price) desc) as rk
from sales
group by 1
)

select seller_id 
from cte
where rk = 1
;
```

**[1083. Sales Analysis II](https://zhuanlan.zhihu.com/p/259959459)** 

same table as 1082

Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products present in the Product table.

```
with s8 as
(select distinct buyer_id
from sales
where product_id in (select product_id from product where product_name = 'S8')
),
iphone as
(select distinct buyer_id
from sales
where product_id in (select product_id from product where product_name = 'iPhone')
)

select distinct buyer_id
from sales
where buyer_id in (select buyer_id from s8) and buyer_id not in (select buyer_id from iphone) 
;

# method 2
with cte as (
select s.buyer_id, p.product_name
from sales s 
join product p
on s.product_id = p.product_id
)

select distinct buyer_id
from cte
where buyer_id in (select distinct buyer_id from cte where product_name = 'S8')
and buyer_id not in (select distinct buyer_id from cte where product_name = 'iPhone')
;
```

**[1084. Sales Analysis III](https://zhuanlan.zhihu.com/p/259959911)** 

same table as 1082

Write an SQL query that reports the products that were only sold in spring 2019. That is, between 2019-01-01 and 2019-03-31 inclusive.

```
# wrong approach
select *
from product
where product_id not in (select distinct product_id from sales where sales_date between '2019-01-01' and '2019-12-31')
;

# only sold!!
select *
from product
where product_id not in (select distinct product_id from sales where sales_date < '2019-01-01')
and 
product_id not in (select distinct product_id from sales where sales_date > '2019-12-31')
;
```


**[1097. Game Play Analysis V](https://zhuanlan.zhihu.com/p/260246072)** 

(player_id, event_date) is the primary key of this table. This table shows the activity of players of some game. Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.

Activity: player_id | device_id | event_date | games_played

We define the install date of a player to be the first login day of that player.

We also define day 1 retention of some date X to be the number of players whose install date is X and they logged back in on the day right after X, divided by the number of players whose install date is X, rounded to 2 decimal places.

Write an SQL query that reports for each install date, the number of players that installed the game on that day and the day 1 retention.

```
# get the first dates
# left join to get the following day presence and day1 retention

select d1.install_dt, count(distinct d1.player_id) as installs, 
round( sum(case when d2.player_id is not null then 1 else 0 end)/count(distinct d1.player_id) , 2) as day1_retention # numerator can also be count(distinct d2.player_id)
from
(select min(event_date) as install_dt, player_id
from activity
group by 2) d1
left join activity d2 on d1.player_id = d2.player_id and datediff(d2.event_date, d1.install_dt) = 1
group by 1
```

**[1098. Unpopular Books](https://zhuanlan.zhihu.com/p/260250277)** 

books: book_id | name | available_from

orders: order_id | book_id | quantity | dispatch_date

Write an SQL query that reports the books that have sold less than 10 copies in the last year, excluding books that have been available for less than 1 month from today. Assume today is 2019-06-23

```
# books less than 10 copies last year
# books available for less than 1month
# exclude

select b.book_id, b.name
from books b
join 
(select book_id 
from orders
where year(dispatch_date) = 2018
group by 1
having sum(quantity) < 10) tmp on b.book_id = tmp.book_id
where datediff('2019-06-23', b.available_from) >= 30
;

```

**[1107. New Users Daily Count](https://zhuanlan.zhihu.com/p/260280221)** 

There is no primary key for this table, it may have duplicate rows.
The activity column is an ENUM type of ('login', 'logout', 'jobs', 'groups', 'homepage').

traffic: user_id | activity | activity_date

Write an SQL query that reports for every date within at most 90 days from today, the number of users that logged in for the first time on that date. Assume today is 2019-06-30.

```
# first date of each user
# constraint on date range
# count user by date

select login_date, count(user_id) as user_count
from
(select user_id, min(activity_date) as login_date
from traffic
where activity = 'login'
group by 1) tmp
where date_diff('2019-06-30', login_date) <= 90   #login_date >= datesub('2019-06-30', interval 90 day)
;

```

**[1112. Highest Grade For Each Student](https://zhuanlan.zhihu.com/p/260281892)** 

(student_id, course_id) is the primary key of this table.

enrollments: student_id | course_id | grade

Write a SQL query to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest courseid. The output must be sorted by increasing student_id.

```
# order course by grade desc within each student
# rk = 1
# order by student_id

select student_id, course_id, grade
from
(select *, rank() over(partition by student_id order by grade desc, course_id asc) as rk
from enrollments) tmp
where rk = 1
order by 1 # !!! Check your answer before talking to the interviewer
;

```

**[1113. Reported Posts](https://zhuanlan.zhihu.com/p/260283912)** 

There is no primary key for this table, it may have duplicate rows.

The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').

The extra column has optional information about the action such as a reason for report or a type of reaction.

actions: user_id | post_id | action_date | action | extra

Write an SQL query that reports the number of posts reported yesterday for each report reason. Assume today is 2019-07-05.

```
# posts reported yesterday
# count by reason

select extra as report_reason, count(distinct post_id) as report_count
from actions
where action = 'report' and datediff('2019-07-05', action_date) = 1 # do we need "extra is not null" ?
group by 1
;

```


**[1126. Active Businesses](https://zhuanlan.zhihu.com/p/260287403)** 

(business_id, event_type) is the primary key of this table.

Each row in the table logs the info that an event of some type occured at some business for a number of times.

events: business_id | event_type | occurences

Write an SQL query to find all active businesses.

An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

```
# get the avg of each event type
# filter out those greater than avg
# count event types by business

select business_id
from
(select *, avg(occurences) over(partition by event_type) as avg_occ_by_type
from events) tmp
where occurences > avg_occ_by_type
group by 1
having count(event_type) > 1
;

```

**[1127. User Purchase Platform](https://zhuanlan.zhihu.com/p/260379510)** 

**hard and smart, similar to create histgram, group twice; and also need to add the zero lines; left join is key!**

The table logs the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.

(user_id, spend_date, platform) is the primary key of this table. The platform column is an ENUM type of ('desktop', 'mobile').

spending: user_id | spend_date | platform | amount

Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date. 

```
# find users who use both on each day
# filter out those users 
# aggregate the remaining -> mobile or desktop only
# aggregate the filtered out data in #2 and union back and order by date
# impute the both of missing dates

with tmp1 as
(
select spend_date, user_id, case when count(*) = 2 then 'both' else platform end as platform, sum(amount) as total_amount
from spending
group by 1, 2
),
tmp2 as
(
select distinct spend_date, 'mobile' as platform
from spending
union
select distinct spend_date, 'desktop' as platform
from spending
union
select distinct spend_date, 'both' as platform
from spending
)

select tmp2.spend_date, tmp2.platform, coalesce(sum(tmp1.total_amount), 0) as total_amount,
coalesce(count(distinct tmp1.user_id), 0) as total_users
from tmp2 left join tmp1
on tmp2.spend_date = tmp1.spend_date and tmp2.platform = tmp1.platform
group by 1,2

```


**[1132. Reported Posts II](https://zhuanlan.zhihu.com/p/260384789)** 

There is no primary key for this table, it may have duplicate rows.

The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').

The extra column has optional information about the action such as a reason for report or a type of reaction.

actions: user_id | post_id | action_date | action | extra

post_id is the primary key of this table.
Each row in this table indicates that some post was removed as a result of being reported or as a result of an admin review.

removals: post_id | remove_date

Write an SQL query to find the average for daily percentage of posts that got removed after being reported as spam, rounded to 2 decimal places.

```
# filter posts: report, spam
# left join table and calculate the daily percentage
# get the average of percentage and round

select round(avg(daily_pctg),2) as avg_daily_pctg
from
(
select a.action_date, count(distinct r.post_id) / count(distinct r.post_id)*100 as daily_pctg
from actions a 
left join removal r
on a.post_id = r.post_id
where a.action = 'report' and a.extra = 'spam'
group by a.action_date
) tmp
;

```


**[1141. User Activity for the Past 30 Days I](https://zhuanlan.zhihu.com/p/260555889)** 

There is no primary key for this table, it may have duplicate rows. The activity_type column is an ENUM of type ('open_session', 'end_session', 'scroll_down', 'send_message'). The table shows the user activities for a social media website. Note that each session belongs to exactly one user.

activity: user_id | session_id | activity_date | activity_type

Write an SQL query to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on some day if he/she made at least one activity on that day.

```
# filter by date
# count user by date

select activity_date as day, count(distinct user_id) as active_users
from activity
where activity_date <= '2019-07-27' and date_diff('2019-07-27', activity_date ) <= 30
group by 1
having activity_type not null
;

# or use subquery
select activity_date as day, count(distinct user_id) as active_users
from (select distinct activity_date, user_id
from activity
where activity_date > date_sub('2019-07-27', interval 30 day) and activity_date <= '2019-07-27'
having count(distinct activity_type) >= 1) tmp
group by 1
;

```

**[1142. User Activity for the Past 30 Days II](https://zhuanlan.zhihu.com/p/260558715)** 

Table refers to 1141

Write an SQL query to find the average number of sessions per user for a period of 30 days ending 2019-07-27 inclusively, rounded to 2 decimal places. The sessions we want to count for a user are those with at least one activity in that time period.

```
# filter date 
# count sessions by user
# calculate average

select round(avg(num_session), 2) as average_sessions_per_user
from
(
select user_id, count(distinct session_id) as num_session
from activity
where activity_date > date_sub('2019-07-27', interval 30 day) and activity_date <= '2019-07-27' and activity_type is not null
group by 1
) tmp
;

```

**[1148. Article Views I](https://zhuanlan.zhihu.com/p/260564257)** 
# Both pandas and sql can directly compare two columns in each row

There is no primary key for this table, it may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.

views: article_id | author_id | viewer_id | view_date

Write an SQL query to find all the authors that viewed at least one of their own articles, sorted in ascending order by their id.

```
select distinct author_id as id
from views
where author_id = viewer_id
order by 1
;

```


**[1149. Article Views II](https://zhuanlan.zhihu.com/p/260566677)** 
# Need to be cautious about the asking!
Refers to table in 1148

Write an SQL query to find all the people who viewed more than one article on the same date, sorted in ascending order by their id.
```
select distinct viewer_id as id
from 
(select viewer_id, view_date
from views
group by 1,2
having count(distinct article_id) > 1
) tmp
order by 1
;

```


**[1158. Market Analysis I](https://zhuanlan.zhihu.com/p/260616599)** 

user_id is the primary key of this table.
This table has the info of the users of an online shopping website where users can sell and buy items.

users: user_id | join_date | favorite_brand

order_id is the primary key of this table.
item_id is a foreign key to the Items table.
buyer_id and seller_id are foreign keys to the Users table.

orders: order_id | order_date | item_id | buyer_id | seller_id

item_id is the primary key of this table.

items: item_id | item_brand

Write an SQL query to find for each user, the join date and the number of orders they made as a buyer in 2019.

```
# get buyer and #orders in 2019
# join to users table

select u.user_id as buyer_id, u.join_date, coalese(tmp.num_order, 0) as orders_in_2019
from users u
left join 
(
select buyer_id, count(order_id) as num_order
from orders
where year(order_date) = 2019
group by 1
) tmp
on u.user_id = tmp.buyer_id
;

```

**[1159. Market Analysis II](https://zhuanlan.zhihu.com/p/260621429)** 

user_id is the primary key of this table.
This table has the info of the users of an online shopping website where users can sell and buy items.

users: user_id | join_date | favorite_brand

order_id is the primary key of this table.
item_id is a foreign key to the Items table.
buyer_id and seller_id are foreign keys to the Users table.

orders: order_id | order_date | item_id | buyer_id | seller_id

item_id is the primary key of this table.

items: item_id | item_brand

Write an SQL query to find for each user, whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no.

It is guaranteed that no seller sold more than one item on a day.

```
# rank by seller and date
# no second item -> no
# yes second item -> check

select u.user_id as seller_id, coalese(case when i.item_id = second.item_id then 'yes' else 'no' end, 'no') as 2nd_item_fav_brand
from users u
left join items i on u.item_brand = i.item_brand
left join
(
select seller_id, item_id
from(
select seller_id, item_id, rank() over(partition by seller_id order by order_date) as rk
from orders) tmp
where rk = 2) second
on u.user_id = second.seller_id
;


```

**[1164. Product Price at a Given Date](https://zhuanlan.zhihu.com/p/260622724)** 

(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.

products: product_id | new_price | change_date

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

```
# tbl1: has price change before 2019-08-16
# tbl2: most recent price change after 2019-08-16
with tmp1 as
(
select product_id, new_price as price
from (select product_id, new_price, rank() over(partition by product_id order by change_date desc) as rk
from products where change_date <= '2019-08-16') tmp
where rk = 1
),
tmp2 as
(select distinct product_id, 10 as price 
from products 
where change_date > '2019-08-16' and product_id not in (select product_id from tmp1) # change_date condition may not be necessary
)

select *
from tmp1
union
select * 
from tmp2
order by price desc, product_id asc;
```

**[1173. Immediate Food Delivery I](https://zhuanlan.zhihu.com/p/260721471)** 

delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).

delivery: delivery_id | customer_id | order_date | customer_pref_delivery_date

If the preferred delivery date of the customer is the same as the order date then the order is called immediate otherwise it's called scheduled.

Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal places.

```
select round(sum(case when order_date = customer_pref_delivery_date then 1 else 0) / count(delivery_id) * 100.0, 2) as immediate_percentage
from delivery
;

# or

select round(avg(order_date = customer_pref_delivery_date) * 100.0, 2) as immediate_percentage
from delivery
;

```

**[1174. Immediate Food Delivery II](https://zhuanlan.zhihu.com/p/260724111)** 

delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).

delivery: delivery_id | customer_id | order_date | customer_pref_delivery_date

If the preferred delivery date of the customer is the same as the order date then the order is called immediate otherwise it's called scheduled.

The first order of a customer is the order with the earliest order date that customer made. It is guaranteed that a customer has exactly one first order.

Write an SQL query to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

```
select round(avg(order_date = customer_pref_delivery_date)*100,2) as immediate_percentage
from
(select *, rank() over(partition by customer_id order by order_date asc) as rk
from delivery) tmp
where rk = 1
;
```

**[1179. Reformat Department Table](https://zhuanlan.zhihu.com/p/260726972)** 

(id, month) is the primary key of this table.
The table has information about the revenue of each department per month.
The month has values in ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"].

department: id | revenue | month

Write an SQL query to reformat the table such that there is a department id column and a revenue column for each month.

```
# pivot table
select id, 
sum(case when month = 'Jan' then revenue else null end) as Jan_Revenue,
sum(case when month = 'Feb' then revenue else null end) as Feb_Revenue,
sum(case when month = 'Mar' then revenue else null end )as Mar_Revenue,
sum(case when month = 'Apr' then revenue else null end) as Apr_Revenue,
sum(case when month = 'May' then revenue else null end) as May_Revenue,
sum(case when month = 'Jun' then revenue else null end) as Jun_Revenue,
sum(case when month = 'Jul' then revenue else null end) as Jul_Revenue,
sum(case when month = 'Aug' then revenue else null end) as Aug_Revenue,
sum(case when month = 'Sep' then revenue else null end) as Sep_Revenue,
sum(case when month = 'Oct' then revenue else null end) as Oct_Revenue,
sum(case when month = 'Nov' then revenue else null end) as Nov_Revenue,
sum(case when month = 'Dec' then revenue else null end) as Dec_Revenue
from department
group by 1
;
```

**[1193. Monthly Transactions I](https://zhuanlan.zhihu.com/p/260881320)** 

id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].

transaction: id | country | state | amount | trans_date

Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

```
select date_format(trans_date, '%Y-%m') as month, country,  # date_format function!
count(id) as num_trans,
sum(amount) as sum_trans,
count(case when state = 'approved' then id else end) as num_app_trans,
sum(case when state = 'approved' then amount else 0 end) as sum_app_trans
from transaction
group by 1,2
;
```


**[1194. Tournament Winners](https://zhuanlan.zhihu.com/p/260882793)** 

player_id is the primary key of this table.
Each row of this table indicates the group of each player.

players: player_id | group_id

match_id is the primary key of this table.
Each row is a record of a match, first_player and second_player contain the player_id of each match.
first_score and second_score contain the number of points of the first_player and second_player respectively.
You may assume that, in each match, players belong to the same group.

matches: match_id | first_player | second_player | first_score | second_score

The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest player_id wins.

Write an SQL query to find the winner in each group.

```
# match_id | player_id | score
# group_id | player_id | total | rk
# group_id | player_id 

with score as
(
select first_player as player_id, first_score as score
from matches
union all
select second_player as player_id, second_score as score
from matches
),
total as
(
select p.group_id, p.player_id, row_number() over(partition by p.group_id order by ifnull(s.total,0) desc, p.player_id asc) as rk
from players p left join 
  (
  select player_id, sum(score) as total
  from score
  group by 1
  ) s
on p.player_id = s.player_id
)

select group_id, player_id
from total
where rk = 1
;
```


**[1204. Last Person to Fit in the Elevator](https://zhuanlan.zhihu.com/p/260888277)** 

person_id is the primary key column for this table.

This table has the information about all people waiting for an elevator.

The person_id and turn columns will contain all numbers from 1 to n, where n is the number of rows in the table.

queue: person_id | person_name | weight | turn

The maximum weight the elevator can hold is 1000.

Write an SQL query to find the person_name of the last person who will fit in the elevator without exceeding the weight limit. It is guaranteed that the person who is first in the queue can fit in the elevator.

```
select person_name
from (
  select person_name, cum_w, lead(cum_w,1) over(order by turn) next_cum_w
  from (select *, sum(weight) over(order by turn) as cum_w
  from queue) tmp
) tmp2
where cum_w <= 1000 and next_cum_w > 1000
;
```

**[1205. Monthly Transactions II](https://zhuanlan.zhihu.com/p/260890494)** 

id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"]

transactions:id | country | state | amount | trans_date

Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key to the id column of Transactions table.
Each chargeback corresponds to a transaction made previously even if they were not approved.

chargebacks: trans_id | charge_date

Write an SQL query to find for each month and country, the number of approved transactions and their total amount, the number of chargebacks and their total amount.

Note: In your query, given the month and country, ignore rows with all zeros.

```
select date_format(t.trans_date, '%Y-%m') as month, t.country,
sum(t.state = 'approved') as approved_count, 
sum(case when t.state = 'approved' then t.amount else 0 end) as approved_amount,
count(distinct c.trans_id) as chargeback_count,
sum(case when c.trans_id is not null then t.amount else 0 end) as chargeback_amount
from transactions t left join
chargebacks c on t.id = c.trans_id
group by 1, 2
;
```

**[1211. Queries Quality and Percentage](https://zhuanlan.zhihu.com/p/260937964)** 

There is no primary key for this table, it may have duplicate rows.

This table contains information collected from some queries on a database.

The position column has a value from 1 to 500.

The rating column has a value from 1 to 5. Query with rating less than 3 is a poor query.

queries: query_name | result | position | rating

We define query quality as: The average of the ratio between query rating and its position.

We also define poor_query_percentage as: The percentage of all queries with rating less than 3.

Write an SQL query to find each query name, the quality and poor_query_percentage.

Both quality and poor_query_percentage should be rounded to 2 decimal places.

```
select query_name,
round(avg(rating/position),2) as quality, round(avg(rating < 3) * 100.0,2) as poor_query_percentage
from queries
group by 1
;
```


**[1212. Team Scores in Football Tournament](https://zhuanlan.zhihu.com/p/260941002)** 

team_id is the primary key of this table.
Each row of this table represents a single football team.

teams: team_id | team_name

match_id is the primary key of this table.
Each row is a record of a finished match between two different teams. 
Teams host_team and guest_team are represented by their IDs in the teams table (team_id) and they scored host_goals and guest_goals goals respectively.

matches: match_id | host_team | guest_team | host_goals | guest_goals

You would like to compute the scores of all teams after all matches. Points are awarded as follows:

A team receives three points if they win a match (Score strictly more goals than the opponent team).
A team receives one point if they draw a match (Same number of goals as the opponent team).
A team receives no points if they lose a match (Score less goals than the opponent team).
Write an SQL query that selects the team_id, team_name and num_points of each team in the tournament after all described matches. Result table should be ordered by num_points (decreasing order). In case of a tie, order the records by team_id (increasing order).

```
with points as
(
select *,
if(host_goals > guest_goals, 3, if(host_goals = guest_goals, 1, 0)) as host_point,
if(host_goals < guest_goals, 3, if(host_goals = guest_goals, 1, 0)) as guest_point
from matches
),
each_team as
(
select host_team as team_id, host_point as point
from matches
union all
select guest_team as team_id, guest_point as point
from matches
)

select t.team_id, t.team_name, sum(coalesce(e.point,0)) as num_points
from teams t left join each_team e
on t.team_id = e.team_id
group by 1,2
order by 3 desc, 1
;
```


**[1225. Report Contiguous Dates (hard)](https://zhuanlan.zhihu.com/p/261056901)** 

Primary key for this table is fail_date.
Failed table contains the days of failed tasks

failed: failed_date

Primary key for this table is success_date.
Succeeded table contains the days of succeeded tasks.

succeeded: succeeded_date

A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write an SQL query to generate a report of period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Order result by start_date.

```
# group consecutive succeeded / failed dates together

# method 1 - 
with base_tbl as 
(
select 'succeeded' as period_state, succeeded_date as date
from succeeded
where succeeded_date between '2019-01-01' and '2019-12-31'
union
select 'failed' as period_state, failed_date as date
from failed
where failed_date between '2019-01-01' and '2019-12-31'
),
group_tbl as 
(
select *, 
case period_state when 'succeeded' then
  datediff(date, '2018-01-01') - row_number() over(partition by period_state order by date)
  when 'failed' then
  datediff(date, '2017-01-01') - row_number() over(partition by period_state order by date)
  else -1000 end 
as grp
from base_tbl
),
rel_tbl as
(
select period_state, grp, min(date) as start_date, max(date) as end_date
from group_tbl
group by 1,2
)

select period_date, start_date, end_date
from rel_tbl
order by 2
;


# method 2 - concise way
select 'succeeded' as period_state, min(succeeded_date) as start_date, max(succeeded_date) as end_date
from succeeded
where succeeded_date between '2019-01-01' and '2019-12-31'
group by dayofyear(succeeded_date) - row_number() over(order by succeeded_date)

union

select 'failed' as period_state, min(failed_date) as start_date, max(failed_date) as end_date
from failed
where failed_date between '2019-01-01' and '2019-12-31'
group by dayofyear(failed_date) - row_number() over(order by failed_date)
order by start_date
;

```

**[1241. Number of Comments per Post](https://zhuanlan.zhihu.com/p/261060205)** 

There is no primary key for this table, it may have duplicate rows.

Each row can be a post or comment on the post.

**parent_id is null for posts.**

parent_id for comments is sub_id for another post in the table.

submissions: sub_id | parent_id

Write an SQL query to find number of comments per each post.

Result table should contain post_id and its corresponding number of comments, and must be sorted by post_id in ascending order.

Submissions may contain duplicate comments. You should count the number of unique comments per post.

Submissions may contain duplicate posts. You should treat them as one post.

```
with posts as
(
select distinct sub_id as post_id
from submissions
where parent_id is null
)

select p.post_id, coalese(count(distinct s.sub_id), 0) as number_of_comments
from posts p left join submissions s
on p.post_id = s.parent_id
group by 1
order by 1
;
```

**[1251. Average Selling Price](https://zhuanlan.zhihu.com/p/261085459)** 

(product_id, start_date, end_date) is the primary key for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.

prices: product_id | start_date | end_date | price

There is no primary key for this table, it may contain duplicates.
Each row of this table indicates the date, units and product_id of each product sold.

unitssold: product_id | purchase_date | units

Write an SQL query to find the average selling price for each product.

average_price should be rounded to 2 decimal places.

```
select u.product_id, round( sum(u.units * p.price) / sum(u.units), 2) as average_price
from prices p right join unitssold u
on p.product_id = u.product_id
and u.purchase_id between p.start_date and p.end_date
group by 1
;
```

**[1264. Page Recommendations](https://zhuanlan.zhihu.com/p/261086655)** 

(user1_id, user2_id) is the primary key for this table.
Each row of this table indicates that there is a friendship relation between user1_id and user2_id.

friendship: user1_id | user2_id

likes: user_id | page_id

Write an SQL query to recommend pages to the user with user_id = 1 using the pages that your friends liked. It should not recommend pages you already liked.

Return result table in any order without duplicates.

```
# friends -> friends liked
# exclude 1 liked
select distinct page_id as recommended_page
from likes
where user_id in (select user_id
from 
  (select user1_id as user_id from friendship where user2_id = 1
  union
  select user2_id as user_id from friendship where user1_id = 1
  ) t
)
and page_id not in (
select page_id from likes where user_id = 1
)
;
```

**[1270. All People Report to the Given Manager](https://zhuanlan.zhihu.com/p/262497801)** 

employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.

employees: employee_id | employee_name | manager_id

Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.

The indirect relation between managers will not exceed 3 managers as the company is small.

Return result table in any order without duplicates.

```
with direct as
(
select employee_id
from employees
where employee_id <> 1 and manager_id = 1
),
indirect1 as 
(
select e.employee_id
from employees e join direct d
on e.manager_id = d.employee_id
),
indirect2 as
(
select e2.employee_id
from employees e2 join indirect1 ind1
on e2.manager_id = ind1.employee_id
)

select * from direct
union
select * from indirect1
union
select * from indirect2
;


## not sure whether the following solution correct or not
## the sql syntax checker can't validate, not sure why
select distinct e.employee_id
from employees e 
left join employees m
on e.manager_id = m.employee_id
left join employees mm
on m.manager_id = mm.employee_id
where e.employee_id <> 1 and
(e.manager_id = 1 or m.manager_id = 1 or mm.manager_id = 1)
;
```


**[1280. Students and Examinations](https://zhuanlan.zhihu.com/p/262501270)** 

student_id is the primary key for this table.
Each row of this table contains the ID and the name of one student in the school.

students: student_id | student_name

subject_name is the primary key for this table.
Each row of this table contains the name of one subject in the school.

subjects: subject_name

There is no primary key for this table. It may contain duplicates.
Each student from the Students table takes every course from Subjects table.
Each row of this table indicates that a student with ID student_id attended the exam of subject_name.

examinations: student_id | subject_name

Write an SQL query to find the number of times each student attended each exam.

Order the result table by student_id and subject_name.

```
select tmp.student_id, tmp.student_name, tmp.subject_name,
sum(case when e.student_id is not null then 1 else 0 end) as attended_exams
from
(select s.student_id, s.student_name, sub.subject_name
from students s cross join subjects sub) tmp
left join examinations e
 on tmp.student_id = e.student_id and tmp.subject_name = e.subject_name
group by 1,2,3
order by 1,3
;
```

**[1285. Find the Start & End # of Continuous Ranges](https://zhuanlan.zhihu.com/p/262505261)** 

id is the primary key for this table.
Each row of this table contains the ID in a log Table.

logs: log_id

Since some IDs have been removed from Logs. Write an SQL query to find the start and end number of continuous ranges in table Logs.

Order the result table by start_id.

```
select min(log_id) as start_id, max(log_id) as end_id
from logs
group by log_id - row_number() over(order by log_id)
order by 1
;

### 上面链接的解法
with cte as
(select log_id, log_id - row_number() over(order by log_id) as rk
from logs)

select first_value(log_id) over(partition by rk order by log_id) as start_id,
first_value(log_id) over(partition by rk order by log_id desc) as start_id
from cte
order by start_id
;
```

**[1294. Weather Type in Each Country](https://zhuanlan.zhihu.com/p/262903848)** 

country_id is the primary key for this table. Each row of this table contains the ID and the name of one country.

countries: country_id | country_name

(country_id, day) is the primary key for this table. Each row of this table indicates the weather state in a country for one day.

weather: country_id | weather_state | day

Write an SQL query to find the type of weather in each country for November 2019.

The type of weather is Cold if the average weather_state is less than or equal 15, Hot if the average weather_state is greater than or equal 25 and Warm otherwise.

Return result table in any order.

```
select c.country_name, 
case when avg_weather <= 15 then 'Cold' when avg_weather >= 25 then 'Hot' else 'Warm' end as weather_type
from countries c join 
(
select country_id, avg(weather_state) as avg_weather
from weather
where month(day) = 11 and year(day) = 2019
group by 1
) tmp
on c.country_id = tmp.country_id
;

## another method
select c.country_name, 
case when avg(w.weather) <= 15 then 'Cold' when avg(w.weather) >= 25 then 'Hot' else 'Warm' end as weather_type
from countries c join weather w
on c.country_id = w.country_id
where date_format(day, '%Y-%m') = '2019-11'
group by 1
;
```

**[1303. Find the Team Size](https://zhuanlan.zhihu.com/p/262911231)** 

employee_id is the primary key for this table.
Each row of this table contains the ID of each employee and their respective team.

employee: employee_id | team_id

Write an SQL query to find the team size of each of the employees.

Return result table in any order.

```
select e.employee_id, tmp.team_size
from employee e
left join
(select team_id, count(distinct employee_id) as team_size
from employee
group by 1) tmp
on e.team_id = tmp.team_id
;

## use window function
select employee_id, count(employee_id) over(partition by team_id) as team_size
from employee
order by 1
;
```

**[1308. Running Total for Different Genders](https://zhuanlan.zhihu.com/p/262915226)** 

(gender, day) is the primary key for this table. A competition is held between females team and males team. Each row of this table indicates that a player_name and with gender has scored score_point in someday. Gender is 'F' if the player is in females team and 'M' if the player is in males team.

scores: player_name | gender | day | score_points

Write an SQL query to find the total score for each gender at each day.

Order the result table by gender and day

```
## This syntax is a little funky the first time you see it. But, the window function is evaluated after the GROUP BY. What this says is to sum the sum of the total 

select gender, day, sum(sum(score_points)) over(partition by gender order by day) as total
from scores
group by 1, 2
order by 1, 2
;
```

**[1321. Restaurant Growth (Hard)](https://zhuanlan.zhihu.com/p/262917262)** 

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Write an SQL query to compute moving average of how much customer paid in a 7 days window (current day + 6 days before) .

The query result format is in the following example:

Return result table ordered by visited_on.

average_amount should be rounded to 2 decimal places, all dates are in the format ('YYYY-MM-DD').

```
with cte as
(
select visited_on,
row_number() over(order by visited) as rown,
sum(sum(amount)) over(order by visited_on rows 6 preceding) as total
from customer
group by 1
)

select visited_on, round(total/7.0, 2) as average_amount
from cte
where rown >= 7
;
```

**[1322. Ads Performance](https://zhuanlan.zhihu.com/p/262925529)** 

(ad_id, user_id) is the primary key for this table.
Each row of this table contains the ID of an Ad, the ID of a user and the action taken by this user regarding this Ad.
The action column is an ENUM type of ('Clicked', 'Viewed', 'Ignored').

ads: ad_id | user_id | action

A company is running Ads and wants to calculate the performance of each Ad.

Performance of the Ad is measured using Click-Through Rate (CTR) where: CTR = 0 if ad total clicks + ad total views = 0 else = ad total clicks / (ad total clicks + ad total views) * 100

Write an SQL query to find the ctr of each Ad.

Round ctr to 2 decimal points. Order the result table by ctr in descending order and by ad_id in ascending order in case of a tie.

```
with cte as
(
select ad_id, 
sum(case when action = 'Clicked' then 1 else 0 end) as clicks,
sum(case when action = 'Viewed' then 1 else 0 end) as views
group by 1
)

select ad_id,
round(
case when clicks = 0 and views = 0 then 0 else clicks / (clicks + views) * 100.0
,2) as ctr
from cte
order by 2 desc, 1
;
```

**[1327. List the Products Ordered in a Period](https://zhuanlan.zhihu.com/p/263247721)** 

product_id is the primary key for this table.
This table contains data about the company's products.

products: product_id | product_name | product_category

There is no primary key for this table. It may have duplicate rows.
product_id is a foreign key to Products table.
unit is the number of products ordered in order_date.

orders: product_id | order_date | unit

Write an SQL query to get the names of products with greater than or equal to 100 units ordered in February 2020 and their amount.

Return result table in any order.

```
select o.product_id, sum(o.unit) as unit
from orders o join products p on
o.product_id = p.product_id
where date_format(o.order_date, '%Y-%m') = '2020-02'
group by 1
having sum(o.unit) >= 100
;
```

**[1336. Number of Transactions per Visit (Hard)](https://zhuanlan.zhihu.com/p/263352450)** 

(user_id, visit_date) is the primary key for this table.
Each row of this table indicates that user_id has visited the bank in visit_date.

visits: visit_id | visit_date

There is no primary key for this table, it may contain duplicates.
Each row of this table indicates that user_id has done a transaction of amount in transaction_date.
It is guaranteed that the user has visited the bank in the transaction_date.(i.e The Visits table contains (user_id, transaction_date) in one row)

transactions: user_id | transaction_date | amount

A bank wants to draw a chart of the number of transactions bank visitors did in one visit to the bank and the corresponding number of visitors who have done this number of transaction in one visit.

Write an SQL query to find how many users visited the bank and didn't do any transactions, how many visited the bank and did one transaction and so on.

The result table will contain two columns:

transaction_count which is the number of transactions done in one visit.
visits_count which is the corresponding number of users who did transaction_count in one visit to the bank.
transaction_count should take all values from 0 to max(transaction_count) done by one or more users.

Order the result table by transaction_count.

```
with full_cnt as
(
select row_number() over() as transaction_count from transactions
union
select 0 as transaction_count
),
trans as
(
select v.user_id, v.visit_date,
ifnull(count(t.amount) over(partition by v.user_id, v.visit_date), 0) as transaction_count
from visits v left join transactions t
on v.user_id = t.user_id and v.visit_date = t.transaction_date
group by 1, 2
)

select trans.transaction_count, 
ifnull(count(distinct trans.user_id, trans.visit_date), 0) as visits_count
from trans right join full_cnt
on trans.transaction_count = full_cnt.transaction_count
where full_cnt.transaction_count <= (select max(transaction_count) from trans)
group by 1
order by 1
;
```
