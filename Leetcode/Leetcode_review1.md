**[175. Combine Two Tables](https://zhuanlan.zhihu.com/p/249989779)** 
> Person: PersonId(Primary key) | FirstName | LastName

> Address: AddressId(Primary key) | PersonId | City | State

Write a SQL query for a report that provides the following information for each person in the Person table, regardless if there is an address for each of those people: FirstName, LastName, City, State

```
# person left join address
# select columns
select p.FirstName, p.LastName, a.City, a.State
from person p 
left join address a 
on p.personid = a.personid
```


**[176. Second Highest Salary](https://zhuanlan.zhihu.com/p/250015043)** 
> Employee: Id(Primary key) | Salary

Write a SQL query to get the second highest salary from the Employee Table. For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.

 **if not using sub-query, it will return nothing instead of null when there is no row satisfying the condition**

```
# m1. the largest smaller than the largest
select max(salary) as secondhighestsalary
from employee
where salary < (select max(salary) from employee)

# m2. dense ranking and the second largest
select max(case when rk = 2 then salary else null end) as secondhighestsalary
from
(select salary, dense_rank() over(order by salary desc) as rk
from employee) temp
;

# m3. order by and limit
select
(select distinct salary
from employee
order by salary desc
limit 1 offset 1)
 as secondhighestsalary;
```

**[177. Nth Highest Salary](https://zhuanlan.zhihu.com/p/250023331)** 
> Employee: Id(Primary key) | Salary

Write a SQL query to get the nth highest salary from the Employee table. For example, given the above Employee table, the nth highest salary where n= 2 is 200. If there is no nth highest salary, then the query should return null.
```
create function getnthhighest(n int) returns int
begin
declare p int;
set p = n - 1;
 return (
   select * from
   (select distinct salary 
   from employee 
   order by salary desc 
   limit 1 offset p) as nthhighest
 )
;
end

```

**[178. Rank Scores](https://zhuanlan.zhihu.com/p/250429998)** 
> Scores: Id(Primary key) | Score

Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.
```
select score, dense_rank() over(order by score desc) as 'Rank'
from scores;
```

**[180. Consecutive Numbers](https://zhuanlan.zhihu.com/p/250442363)** 
> logs: Id(Primary key) | Num

Write a SQL query to find all numbers that appear at least three times consecutively. For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.
```
# method 1 - using lead()
select distinct num
from (select num, lead(num,1) over(order by id) as next1, lead(num, 2) over(order by id) as next2 from logs) temp
where num = next1 and num = next2
;

# method 2 -  sub query
select distinct l1.num
from logs l1
where (id+1) in (select num from logs l2 where l2.num = l1.num)
and (id+2) in (select num from logs l2 where l2.num = l1.num)

select distinct l1.num
from logs l1
join logs l2 on l1.id + 1 = l2.id
join logs l3 on l1.id + 2 = l3.id
where l1.num = l2.num and l2.num = l3.num
;
```

**[181. Employees Earning More Than Their Managers](https://zhuanlan.zhihu.com/p/250453101)** 
> Employee: Id(Primary key) | name | salary | managerid

The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.
```
select e.name as **'Employee'**
from employee e left join employee m
on e.managerid = m.id
where m.salary < e.salary
;
```

**[182. Duplicate Emails](https://zhuanlan.zhihu.com/p/251960784)** 
> Person: Id(Primary key) | email

Write a SQL query to find all duplicate emails in a table named Person. For example, your query should return the following for the above table:
```
select email # ! no need for distinct, redundant for group by
from person
group by 1
having count(*) > 1
;

# self join
select distinct a.email
from person a join person b
on a.email = b.email and a.id <> b.id
;
```

**[183. Customers Who Never Order](https://zhuanlan.zhihu.com/p/251983949)** 
> Customers: Id(Primary key) | Name

> Orders: Id(Primary key) | CustomerId

Write a SQL query to find all customers who never order anything. Using the above tables as an example, return the following:
```
select name as 'customers'
from Customers
where id not in (select customerid from orders)
;

# left join
select name
from customers c
left join orders o
on c.id = o.customerid
where o.id is null
;
```

**[184. Department Highest Salary](https://zhuanlan.zhihu.com/p/251983949)** 
> Employee: Id(Primary key) | Name | Salary |DepartmentId

> Department: Id(Primary key) | Name

Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, your SQL query should return the following rows (order of rows does not matter).
```
# find max salary by department ; join back to the original table and department table
# if we want all the department even those without any employee; 
select d.name as department, e.name as employee, e.salary
from department d
left join employee on d.id = e.departmentid
inner join
(select departmentid, max(salary) as m_salary
from employee
group by 1) m
on d.id = m.departmentid and e.salary = t.m_salary
;

# use CTE and join
```

**[185. Department Top Three Salaries](https://zhuanlan.zhihu.com/p/252197890)** 
> Employee: Id(Primary key) | Name | Salary |DepartmentId

> Department: Id(Primary key) | Name

Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows (order of rows does not matter).
```
# get rank of salary within group ; find the ones with rk <= 3

select d.name as department, e.name as employee, e.salary
from department d
left join (select name, salary, row_number() over(partition by departmentid order by salary desc) as rk, departmentid
from employee) e
on d.id = e.departmentid
where e.rk <= 3;
```


**[196. Delete Duplicate Emails](https://zhuanlan.zhihu.com/p/252243481)** 
> Person: Id(Primary key) | Email

Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id. For example, after running your query, the above Person table should have the following rows
```
# Wrong method!!! Can't directly do this
delete from person
where id not in (select min(id) from person group by email)
;

# Correct method
delete from person
where id not in (select mid from (select min(id) as mid from person group by email) as tmp)
;

delete p1 from person p1, person p2
where p1.email = p2.email and p1.id > p2.id
;
```


**[197. Rising Temperature](https://zhuanlan.zhihu.com/p/252403796)** 
> weather: id(Primary key) | RecordDate | temperature

Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday). Return the result table in any order.
```
# method 1: window function - not correct to use lag() only since not working for non-consecutive days
# each table need to have an alias
select id
from ( select id, recorddate, temperature - lag(temperature, 1) over(order by recorddate) as temp_diff,
datediff(recorddate, lag(recorddate, 1) over(order by recorddate)) as date_diff
from weather) tmp
where temp_diff > 0 and date_diff = 1
;

# method 2: join
select curr.id
from weather curr join weather prev
on datediff(curr.recorddate, prev.recorddate) = 1 and curr.temperature > prev.temperature
;
```


**[262. Trips and Users](https://zhuanlan.zhihu.com/p/252454836)** 
> trips: id(Primary key) | client_id | driver_id | city_id | status | request_at

> users: userid(Primary key) | banned | role

Write a SQL query to find the cancellation rate of requests made by unbanned users (both client and driver must be unbanned) between Oct 1, 2013 and Oct 3, 2013. The cancellation rate is computed by dividing the number of canceled (by client or driver) requests made by unbanned users by the total number of requests made by unbanned users.
```
select request_at as day, round(
    count(distinct case when status like "cancelled%" then id else null end) / count(distinct id)
    , 2) as 'Cancellation Rate'
from trips
where client_id not in (select users_id from users where banned = 'Yes')
and driver_id not in (select users_id from users where banned = 'Yes')
and request_at between '2013-10-01' and '2013-10-03'
group by 1
;
```

**[511. Game Play Analysis I](https://zhuanlan.zhihu.com/p/254355214)** 
> activity: player_id(Primary key) | device_id | event_date | games_played

Write an SQL query that reports the first login date for each player.
```
select player_id, min(event_date) as first_login
from activity
group by 1
order by 1
;
```

**[512. Game Play Analysis II](https://zhuanlan.zhihu.com/p/254370126)** 
> activity: player_id(Primary key) | device_id | event_date | games_played

Write a SQL query that reports the device that is first logged in for each player.
```
#window function

select player_id, device_id
from (select player_id, device_id, row_number() over(partition by player_id order by event_date) as rown from activity) tmp
where rown = 1
;

select a1.player_id, a1.device_id
from activity a1 join (select player_id, min(event_date) as first_login
from activity
group by 1) t on a1.player_id = t.player_id and a1.event_date = t.first_login
order by 1
;
```

**[534. Game Play Analysis III](https://zhuanlan.zhihu.com/p/254412551)** 
> activity: player_id(Primary key) | device_id | event_date | games_played

Write an SQL query that reports for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date. Check the example for clarity.
```
#window function
select player_id, event_date, sum(games_played) over(partition by player_id order by event_date) as games_played_so_far
from activity
order by 1, 2
;

# the author gave other method using related join, but I can not understand
```

**[550. Game Play Analysis IV](https://zhuanlan.zhihu.com/p/254592333)** 
> activity: player_id(Primary key) | device_id | event_date | games_played

Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.
```
# use left join
select round( count(distinct future.player_id) / count(distinct first.player_id), 2) as fraction
from (select player_id, min(event_date) as first_login # can also be derived using window function first_value()
      from activity
      group by 1) first
left join activity future on first.player_id = future.player_id on datediff(future.event_date, first.event_date) = 1
```

**[569. Median Employee Salary](https://zhuanlan.zhihu.com/p/257081415)** 

The Employee Table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

> employee: id(Primary key) | company | salary

Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.
```
select id, company, salary
from
    (select id, company, salary,
    row_number() over(partition by company order by salary) as sal_rk
    count() over(partition by company) as cnt
    from employee
    ) tmp
where (round(cnt/2)=sal_rk or round((cnt+1)/2)=sal_rk)
;

```

**[570. Managers with at Least 5 Direct Reports](https://zhuanlan.zhihu.com/p/257085286)** 

The Employee Table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

> employee: id(Primary key) | name | department | managerid

Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. 
```
select e0.name 
from employee e0 join 
(select managerid
from employee
group by 1
having count(distinct id) >= 5) tmp on e0.id = tmp.managerid
;

```

**[571. Find Median Given Frequency of Numbers](https://zhuanlan.zhihu.com/p/257945802)** 

The Numbers table keeps the value of number and its frequency.

> numbers: number | frequency

Write a query to find the median of all numbers and name the result as median. In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0)/2 = 0.

```
select avg(number) as median
from
(select *, 
       sum(frequency) over(order by number) as rolling_cnt,
       (sum(frequency) over())/2.0 as mid
from numbers) as tmp
where mid between rolling_cnt - frequency and rolling_cnt

```

**[574. Winning Candidate](https://zhuanlan.zhihu.com/p/258311949)** 

> candidate: id | name

> vote: id | candidateid

Write a sql to find the name of the winning candidate, the above example will return the winner B.

Notes: You may assume there is no tie, in other words there will be only one winning candidate.

```
select c.name
from candidate c join
(select candidateid #, count(*) as votes
from vote
group by 1
order by count(*) desc
limit 1) as tmp 
on c.id = tmp.candidateid

```
