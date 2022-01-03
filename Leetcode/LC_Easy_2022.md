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
