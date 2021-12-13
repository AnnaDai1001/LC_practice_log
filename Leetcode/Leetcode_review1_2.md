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
