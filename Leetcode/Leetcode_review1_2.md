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
