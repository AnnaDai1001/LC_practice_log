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

**[577. Employee Bonus](https://zhuanlan.zhihu.com/p/258318063)** 

> employee: empid | name | manager | salary

> bonus: empid | bonus

Select all employee's name and bonus whose bonus is < 1000.

```
select e.name, b.bonus
from employee e left join bonus b on e.empid = b.empid
where b.bonus is null or b.bonus < 1000
;

# or use id not in empid with bonus >= 1000

```

**[578. Get Highest Answer Rate Question](https://zhuanlan.zhihu.com/p/258327104)** 

> surveylog: id | action | question_id | answer_id | q_num | timestamp

d means user id; action has these kind of values: "show", "answer", "skip"; answer_id is not null when action column is "answer", while is null for "show" and "skip"; q_num is the numeral order of the question in current session.

Write a sql query to identify the question which has the highest answer rate.

Note:The highest answer rate meaning is: answer number's ratio in show number in the same question.

```

select question_id as 'surveylog'
from surveylog
group by 1
order by sum(ifelse(action = 'answer', 1, 0)) / sum(ifelse(action = 'show', 1, 0)) desc ### order by can be followed by aggregate function
limit 1

```

**[579. Find Cumulative Salary of an Employee(Hard)](https://zhuanlan.zhihu.com/p/258684985)** 

> employee: id | month | salary

Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month.

The result should be displayed by 'Id' ascending, and then by 'Month' descending.

```
select e1.id, e1.month, ifnull(e1.salary, 0) + ifnull(e2.salary, 0) + ifnull(e3.salary, 0) as salary
from
(select id, max(month) as max_month
from employee
group by 1
having count(*) > 1
) maxmonth
left join
employee e1 on maxmonth.id = e1.id and maxmonth.max_month > e1.month
left join
employee e2 on e2.id = e1.id and e2.month = e1.month - 1
left join
employee e3 on e3.id = e1.id and e3.month = e1.month - 2
order by 1 asc, 2 desc
;
```

**[580. Count Student Number in Departments](https://zhuanlan.zhihu.com/p/258693620)** 

> student: student_id | student_name | gender | dept_id

> department: dept_id | dept_name

Write a query to print the respective department name and number of students majoring in each department for all departments in the department table (even ones with no current students).

Sort your results by descending number of students; if two or more departments have the same number of students, then sort those departments alphabetically by department name.

```
select d.dept_name, ifnull(count(distinct s.student_id), 0) as student_name
from department d left join student s
on d.dept_id = s.dept_id
group by 1
order by 2 desc, 1 asc
;
```

**[584. Find Customer Referee](https://zhuanlan.zhihu.com/p/258694894)** 

> customer: id | name | referee_id

Write a SQL to get the cumulative sum of an employee's salary over a period of 3 months but exclude the most recent month.

The result should be displayed by 'Id' ascending, and then by 'Month' descending.

```
# method 1, add null in where condition
select name
from customer
where referee_id <> 2 or referee_id is null
;

# method2: exclusion method
select name
from customer
where id not in (select id from customer where referee_id = 2);

# method3: use function
select name
from customer
where ifnull(referee_id, 0) <> 2 # ifnull can also be replaced with coalesce()
;
```


**[585. Investments in 2016](https://zhuanlan.zhihu.com/p/258697688)** 

> insurance: pid | tiv_2015 | tiv_2016 | lat | lon

Write a query to print the sum of all total investment values in 2016 (TIV_2016), to a scale of 2 decimal places, for all policy holders who meet the following criteria:

Have the same TIV_2015 value as one or more other policyholders.
Are not located in the same city as any other policyholder (i.e.: the (latitude, longitude) attribute pairs must be unique).

```
select sum(tiv_2016)
from insurance
where tiv_2015 in (select tiv_2015 from insurance group by 1 having count(*) > 1) and
concat(lat, ",", lon) in (select concat(lat, ",", lon) from insurance group by lat, lon having count(*) = 1)
# or (lat, lon) in (select lat, lon from insurance group by lat, lon having count(*) = 1)
;
```

**[586. Customer Placing the Largest Number of Orders](https://zhuanlan.zhihu.com/p/258700620)** 

> orders: order_number | customer_number | order_date | required_date | shipped_date | status | comment

Query the customer_number from the orders table for the customer who has placed the largest number of orders.

It is guaranteed that exactly one customer will have placed more orders than any other customer.
```
select customer_number
from orders
group by 1
order by count(distinct order_number) desc
limit 1
;

# use of all() function
select customer_number
from orders
group by 1
having count(distinct order_number) >= all(select count(distinct order_number) from orders group by customer_number)
;
```

**[595. Big Countries](https://zhuanlan.zhihu.com/p/258703364)** 

> world: name | continent | area | population | gdp

A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million.

Write a SQL solution to output big countries' name, population and area.

For example, according to the above table, we should output:

```
select name, population, area
from world
where area > 3000000 or population > 25000000
;
```

**[596. Classes More than 5 Students](https://zhuanlan.zhihu.com/p/258705251)** 

> courses: student | class

Please list out all classes which have more than or equal to 5 students.

Note: The students should not be counted duplicate in each course.

```
select class
from courses
group by 1
having count(distinct student) >= 5
;
```

**[597. Friend Requests I: Overall Acceptance Rate](https://zhuanlan.zhihu.com/p/258790804)** 

> friend_request: sender_id | send_to_id | request_date

> request_accepted: requester_id | accepter_id | accept_date

Write a query to find the overall acceptance rate of requests rounded to 2 decimals, which is the number of acceptance divides the number of requests.

Note:

The accepted requests are not necessarily from the table friend_request. In this case, you just need to simply count the total accepted requests (no matter whether they are in the original requests), and divide it by the number of requests to get the acceptance rate.
It is possible that a sender sends multiple requests to the same receiver, and a request could be accepted more than once. In this case, the ‘duplicated’ requests or acceptances are only counted once.
If there is no requests at all, you should return 0.00 as the accept_rate.

```
select round(
             ifnull(
                    (select count(distinct requester_id, accepter_id) from request_accepted)/
                       (select count(distinct sender_id, send_to_id) from friend_request), 
                    0), 
             2) as accept_rate
;
```

**[601. Human Traffic of Stadium](https://zhuanlan.zhihu.com/p/259149233)** 

X city built a new stadium, each day many people visit it and the stats are saved as these columns: id, visit_date, people

> stadium: id | visit_date | people

Please write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive).
**all of those three or more rows should be present**

Note: Each day only have one row record, and the dates are increasing with id increasing.

```
# subqueries - wrong method below!!!
with over100 as(
select id from stadium where people >= 100
)

select *
from stadium
where people >= 100 and
(
(id-2 in over100 and id-1 in over100) or
(id-1 in over100 and id+1 in over100) or
(id+1 in over100 and id+2 in over100)
)
;
# subqueries - correction!!
select *
from stadium
where people >= 100 and
(
((id-2) in (select id from stadium where people >= 100) and (id-1) in (select id from stadium where people >= 100)) or
((id-1) in (select id from stadium where people >= 100) and (id+1) in (select id from stadium where people >= 100)) or
((id+1) in (select id from stadium where people >= 100) and (id+2) in (select id from stadium where people >= 100))
)
;

# solution from the zhihu
with tmp as(
select a.id as id1, b.id as id2, c.id as id3
from stadium a join stadium b on b.id = a.id + 1
join stadium c on c.id = a.id + 2
where a.people >= 100 and b.people >= 100 and c.people >= 100
),
tmp2 as (
select id1 as id from tmp
union
select id2 as id from tmp
union
select id3 as id from tmp
)

select *
from stadium
where id in (select id from tmp2)
;

```

**[602. Friend Requests II: Who Has the Most Friends](https://zhuanlan.zhihu.com/p/259261538)** 

In social network like Facebook or Twitter, people send friend requests and accept others' requests as well.

> request_accepted: requester_id | accepter_id | accept_date

Write a query to find the the people who has most friends and the most friends number under the following rules:

* It is guaranteed there is only 1 people having the most friends.
* The friend request could only been accepted once, which mean there is no multiple records with the same requester_id and accepter_id value.

```
# from zhihu
select c.people as id, sum(c.cnt) as num
from (
select requester_id as people, count(distinct accepter_id) as cnt from request_accepted group by 1
union all
select accepter_id as people, count(distinct requester_id) as cnt from request_accepted group by 1
) c
group by 1
order by sum(c.cnt) desc
limit 1
;

# 
select user1 as id, count(distinct user2) as num
from (
select requester_id as user1, accepter_id as user2 from request_accepted
union all
select accepter_id as user1, requester_id as user2 from request_accepted
)
group by 1
order by count(distinct user2) desc
limit 1;
```

**[603. Consecutive Available Seats](https://zhuanlan.zhihu.com/p/259420594)** 

Several friends at a cinema ticket office would like to reserve consecutive available seats.

> cinema: seat_id | free

Can you help to query all the consecutive available seats order by the seat_id using the following cinema table?

* The seat_id is an auto increment int, and free is bool ('1' means free, and '0' means occupied.).
* Consecutive available seats are more than 2(inclusive) seats consecutively available.

```
# method: similar to that of the stadium traffic question - wrong!!! just need two consecutive
select seat_id from cinema
where free = 1 and
(
((seat_id-2) in (select seat_id from cinema where free = 1) and (seat_id-1) in (select seat_id from cinema where free = 1)) or
((seat_id-1) in (select seat_id from cinema where free = 1) and (seat_id+1) in (select seat_id from cinema where free = 1)) or
((seat_id+1) in (select seat_id from cinema where free = 1) and (seat_id+2) in (select seat_id from cinema where free = 1))
)
;

# correct version:
select seat_id from cinema
where free = 1 and
(
((seat_id-1) in (select seat_id from cinema where free = 1)) or
((seat_id+1) in (select seat_id from cinema where free = 1))
)
;

# use join
select distinct a.seat_id
from cinema a
join cinema b on abs(a.seat_id - b.seat_id) = 1 and a.free = 1 and b.free = 1
order by 1
;
```

**[607. Sales Person](https://zhuanlan.zhihu.com/p/259424830)** 
The table salesperson holds the salesperson information. Every salesperson has a sales_id and a name.

> salesperson: sales_id | name | salary | commission_rate | hire_date

The table company holds the company information. Every company has a com_id and a name.

> company: com_id | name | city

> orders: order_id | order_date | com_id | sales_id | amount

Output all the names in the table salesperson, who didn’t have sales to company 'RED'.

```
select s.name
from salesperson s
where sales_id not in
(select o.sales_id
from orders o join company c on o.com_id = c.com_id
where c.name = 'Red'
)
;
```


**[608. Tree Node](https://zhuanlan.zhihu.com/p/259431458)** 

Given a table tree, id is identifier of the tree node and p_id is its parent node's id.

> tree: id | p_id

Each node in the tree can be one of three types:

* Leaf: if the node is a leaf node.
* Root: if the node is the root of the tree.
* Inner: If the node is neither a leaf node nor a root node.

Write a query to print the node id and the type of the node. Sort your output by the node id. The result for the above sample is:

```
select id, 
case when p_id is null then 'Root'
when id not in (select distinct p_id from tree where p_id is not null) then 'Leaf'
else 'Inner' end as type
from tree
;
```



**[610. Triangle Judgement](https://zhuanlan.zhihu.com/p/259435481)** 

A pupil Tim gets homework to identify whether three line segments could possibly form a triangle.

However, this assignment is very heavy because there are hundreds of records to calculate.

> triangle: x | y | z

return table: x | y | z | triangle (yes/no)

```
select *,
case when abs(x-y) < z and abs(y-z) < x and abs(x-z) < y then 'yes' else 'no' end as 'triangle' # or: x+y>z and x+z>y and y+z>x
from triangle
;
```

**[612. Shortest Distance in a Plane](https://zhuanlan.zhihu.com/p/259469156)** 

Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.

> point_2d: x | y

The shortest distance is 1.00 from point (-1,-1) to (-1,2).

```
select round(min(pow(pow(a.x-b.x, 2)+pow(a.y-b.y, 2), 0.5)), 2) as shortest
from point_2d a join point_2d b
on a.x <> b.x or a.y <> b.y
;
```


**[613. Shortest Distance in a Line](https://zhuanlan.zhihu.com/p/259473185)** 

Table point holds the x coordinate of some points on x-axis in a plane, which are all integers.

> point: x

Write a query to find the shortest distance between two points in these points.

```
select min(abs(a.x - b.x) as shortest
from point a join point b
on a.x <> b.x
;
```

**[614. Second Degree Follower](https://zhuanlan.zhihu.com/p/259487082)** 

> follow: followee | follower

Please write a SQL query to get the amount of each follower’s follower if he/she has one.

```
# use join
select a.follower, count(distinct b.follower) as num
from follow a join follow b
on a.follower = b.followee
group by a.follower
order by a.follower
;
```
