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
