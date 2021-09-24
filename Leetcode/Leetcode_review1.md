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


