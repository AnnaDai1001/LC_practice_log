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
