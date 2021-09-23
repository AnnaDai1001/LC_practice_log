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
