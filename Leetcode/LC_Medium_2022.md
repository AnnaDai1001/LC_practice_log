**[Original Post Here](https://zhuanlan.zhihu.com/p/265354299)** 

**[177. Nth Highest Salary](https://zhuanlan.zhihu.com/p/250023331)** 

employee: id | salary

Write a SQL query to get the nth highest salary from the Employee table. For example, given the above Employee table, the nth highest salary where n= 2 is 200. If there is no nth highest salary, then the query should return null.

```
create function getnthhighestsalary(n int) returns int
begin
  return (
    select distinct salary
    from (
      select *, dense_rank() over(order by salary desc) as rk
      from employee
    ) tmp
    where rk = n
  )
end
;

create function getnthhighestsalary(n int) returns int
begin
declare m int;
set m = n - 1; 
  return (
    select *
    from (
      select distinct salary
      from employee
      order by salary desc
      limit 1 offset m
    ) tmp
  )
end
;
```

**[185. Department Top Three Salaries](https://zhuanlan.zhihu.com/p/252197890)** 

employee: id | name | salary | departmentid

department: id | name

Write a SQL query to find employees who earn the top three salaries in each of the department. For the above tables, your SQL query should return the following rows (order of rows does not matter).

```

;
```
