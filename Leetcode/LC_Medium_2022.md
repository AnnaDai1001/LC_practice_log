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

**[178. Rank Scores](https://zhuanlan.zhihu.com/p/250429998)** 

scores: id | score

Write a SQL query to rank scores. If there is a tie between two scores, both should have the same ranking. Note that after a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no "holes" between ranks.

```
select score, dense_rank() over(order by score desc) as 'Rank'
from scores
order by 1 desc
;
```

**[180. Consecutive Numbers](https://zhuanlan.zhihu.com/p/250442363)** 

logs: id | num

Write a SQL query to find all numbers that appear at least three times consecutively. For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

```
# use window function lag
select distinct num as consecutivenums
from (select *, lead(num,1) over(order by id) as next1, lag(num,2) over(order by id) as next2
from logs) tmp
where num = next1 and num = next2
;

# join tables
select distinct c.num as consecutive nums
from logs c left join logs n1
on c.id = n1.id - 1
left join logs n2
on c.id = n2.id - 2
where c.num = n1.num and c.num = n2.num
;
```


**[184. Department Highest Salary](https://zhuanlan.zhihu.com/p/252005967)** 

employee: id | name | salary | departmentid

department: id | name

Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, your SQL query should return the following rows (order of rows does not matter).

```
select d.name as department, e.name as employee, e.salary
from department d join
(select *, rank() over(partition by departmentid order by salary desc) as rk
from employee) e
on d.id = e.departmentid
where e.rk = 1
;
```


**[534. Game Play Analysis III](https://zhuanlan.zhihu.com/p/254412551)** 

(player_id, event_date) is the primary key of this table. This table shows the activity of players of some game. Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.

activity: player_id | device_id | event_date | games_played

Write an SQL query that reports for each player and date, how many games played so far by the player. That is, the total number of games played by the player until that date. Check the example for clarity.

```
select player_id, event_date, sum(games_played) over(partition by player_id order by event_date) as games_played_so_far
from activity
order by 1,2
;
```
