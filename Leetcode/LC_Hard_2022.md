**[Original Post Here](https://zhuanlan.zhihu.com/p/265354299)** 

**[185. Department Top Three Salaries](https://zhuanlan.zhihu.com/p/252197890)** 

employee: id | name | salary | departmentid

department: id | name

Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows (order of rows does not matter).

```
# find the top three of each department
# join tables
select d.name as department, e.name as employee, e.salary
from department d join
(select *, dense_rank() over(partition by departmentid order by salary desc) as rk
from employee) e
on d.id = e.departmentid
where e.rk <= 3
;
```

**[262. Trips and Users](https://zhuanlan.zhihu.com/p/252454836)** 

The Trips table holds all taxi trips. Each trip has a unique Id, while Client_Id and Driver_Id are both foreign keys to the Users_Id at the Users table. Status is an ENUM type of (‘completed’, ‘cancelled_by_driver’, ‘cancelled_by_client’).

trips: id | client_id | driver_id | city_id | status | request_at

The Users table holds all users. Each user has an unique Users_Id, and Role is an ENUM type of (‘client’, ‘driver’, ‘partner’).

users: users_id | banned | role

Write a SQL query to find the cancellation rate of requests made by unbanned users (both client and driver must be unbanned) between Oct 1, 2013 and Oct 3, 2013. The cancellation rate is computed by dividing the number of canceled (by client or driver) requests made by unbanned users by the total number of requests made by unbanned users.

For the above tables, your SQL query should return the following rows with the cancellation rate being rounded to two decimal places.

```
# join tables
# restrict by date range and unbanned
# calculation by group and round to 2d

select t.request_at as day,
round(sum(case when status like 'cancelled%' then 1 else 0 end) / count(id), 2) as 'Cancellation Rate' 
from trips t left join users d
on d.role = 'driver' and t.driver_id = d.users_id
left join users c
on c.role = 'client' and t.client_id = c.users_id
where request_at between '2013-10-01' and '2013-10-03'
and d.banned = 'No' and c.banned = 'No'
group by 1
order by 1
;
```

**[569. Median Employee Salary](https://zhuanlan.zhihu.com/p/257081415)** 

The Employee Table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.

employee: id | company | salary

Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

```
# get the rank and count
# med: odd -> (count+1)/2; even -> count/2 and count/2 + 1

select id, company, salary
from ( select *, row_number() over(partition by company order by salary) as rk, count() over(partition by company) as cnt
from employee ) tmp
where rk >= cnt/2 and rk <= cnt/2 + 1
# or where condition can be
# where rk = round(cnt/2) or rk = round((cnt+1)/2)
;
```


**[571. Find Median Given Frequency of Numbers](https://zhuanlan.zhihu.com/p/257945802)** 

The Numbers table keeps the value of number and its frequency.

numbers: number | frequency

Write a query to find the median of all numbers and name the result as median. In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0)/2 = 0.

```
# get the rank and count
# med: odd -> (count+1)/2; even -> count/2 and count/2 + 1

# my solution, not sure whether right or not
with tmp1 as
(select *, sum(frequency) over(order by number) as cum_cnt, sum(frequency) over() as tot_cnt
from numbers)

select avg(number) as median
from tmp1
where tot_cnt/2.0 between cum_cnt - frequency and cum_cnt
;

# 网友
select avg(number) as median
from
(select *, sum(frequency) over(order by number) as cum_cnt, (sum(frequency) over())/2.0 as mid
from numbers) tmp
where mid between cum_cnt - frequency and cum_cnt
;
```

**[579. Find Cumulative Salary of an Employee](https://zhuanlan.zhihu.com/p/258684985)** 

The Employee table holds the salary information in a year.

employee: id | month | salary

Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month. The result should be displayed by 'Id' ascending, and then by 'Month' descending.

```
# the requirement is the rolling sum of three-month-window rather than a rolling sum
# most important: understand the requirement

select e1.id, e1.month,
(ifnull(e1.salary, 0) + ifnull(e2.salary, 0) + ifnull(e3.salary, 0)) as salary
from (
select id, max(month) as maxm
from employee
group by 1
having count(*) > 1
) maxmonth
left join employee e1
on maxmonth.id = e1.id and maxmonth.maxm > e1.month
left join employee e2
on e1.id = e2.id and e2.month = e1.month - 1
left join employee e3
on e1.id = e3.id and e3.month = e1.month - 2
order by 1, 2 desc
;
```
