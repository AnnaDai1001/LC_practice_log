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
