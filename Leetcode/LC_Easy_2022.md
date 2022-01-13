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
