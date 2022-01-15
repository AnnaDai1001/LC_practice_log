**[Original Post Here](https://zhuanlan.zhihu.com/p/265354299)** 

**[175. Combine Two Tables](https://zhuanlan.zhihu.com/p/249989779)** 

person: personid | firstname | lastname

address: addressid | personid | city | state

Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people:
firstname, lastname, city, state
```
select p.firstname, p.lastname, a.city, a.state
from person p left join address a
on p.personid = a.personid
;
```

**[176. Second Highest Salary](https://zhuanlan.zhihu.com/p/250015043)** 

employee: id | salary

Write a SQL query to get the second highest salary from the Employee Table. For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.

```
# key: return null when there is no such answer

select 
(select distinct salary
from employee
order by salary desc
limit 1 offset 1)
as secondhighestsalary
;

# method 2
select max(salary)
from employee
where salary < (select max(salary) from employee)
```

**[181. Employees Earning More Than Their Managers](https://zhuanlan.zhihu.com/p/250453101)** 

employee: id | name | salary | managerid

Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

```
select e.name as 'Employee'
from employee e left join employee m
on e.managerid = m.id
where e.salary > m.salary
;
```

**[182. Duplicate Emails](https://zhuanlan.zhihu.com/p/251960784)** 

person: id | email

Write a SQL query to find all duplicate emails in a table named Person.

```
select email
from person
group by email
having count(id) > 1
;

# use join
select distinct a.email
from person a join person b
on a.email = b.email
where a.id <> b.id
```

**[183. Customers Who Never Order](https://zhuanlan.zhihu.com/p/251983949)** 

Suppose that a website contains two tables, the Customers table and the Orders table.

customers: id | name

orders: id | customerid

Write a SQL query to find all customers who never order anything. 

```
# subquery
select name as 'Customers'
from customers
where id not in (select customerid from orders)
;

# join
select c.name as 'Customers'
from customers c left join orders o 
on c.id = o.customerid
where o.id is NULL
;
```

**[197. Rising Temperature](https://zhuanlan.zhihu.com/p/252403796)** 

weather: id | recorddate | temperature

Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday).

Return the result table in any order.
```
select c.*
from weather c left join weather p
on datediff(c.recorddate, p.recorddate) = 1
where c.temperature > p.temperature
;

# M2
select id, recorddate, temperature
from (select *, lag(temperature,1) over(order by recorddate) as p_temperature, lag(recorddate,1) over(order by recorddate) as p_recorddate
from weather
) tmp
where datediff(recorddate, p_recorddate) = 1 # need to check consecutiveness of date as well
and temperature > p_temperature

```

**[196. Delete Duplicate Emails](https://zhuanlan.zhihu.com/p/252243481)** 

person: id | email

Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id

```
delete from person
where email in (select email from person group by email having count(id) > 1)
;

# leetcode solution
delete p1 from person p1, person p2
where p1.email = p2.email and p1.id > p2.id
```

**[511. Game Play Analysis I](https://zhuanlan.zhihu.com/p/254355214)** 

(player_id, event_date) is the primary key of this table. This table shows the activity of players of some game. Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.

activity: player_id | device_id | event_date | games_played

Write an SQL query that reports the first login date for each player.

```
select player_id, min(event_date) as first_login
from activity
group by 1
order by 1
;
```

**[512. Game Play Analysis II](https://zhuanlan.zhihu.com/p/254370126)** 

(player_id, event_date) is the primary key of this table. This table shows the activity of players of some game. Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.

activity: player_id | device_id | event_date | games_played

Write a SQL query that reports the device that is first logged in for each player.

```
select player_id, device_id
from (select *, rank() over(partition by player_id order by event_date) as rk
from activity) tmp
where rk = 1
;
```

**[577. Employee Bonus](https://zhuanlan.zhihu.com/p/258318063)** 

employee: empid | name | supervisor | salary

bonus: empid | bonus

Select all employee's name and bonus whose bonus is < 1000.

```
select e.name, b.bonus
from employee e left join bonus b on e.empid = b.empid
where b.bonus < 1000 or b.bonus is null
;
```
