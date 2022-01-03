# get the separate tables for department average, company average first
# then join the tables and derive comparison

select dept_avg.pay_month, dept_avg.department_id,
case when dept_avg.d_avg > comp_avg.c_avg then 'higher'
     when dept_avg.d_avg < comp_avg.c_avg then 'smaller'
     else 'same' end as 'comparison'
from
(select left(s1.pay_date, 7) as pay_month, e1.department_id, avg(s1.amount) as d_avg
from salary s1
join employee e1 on s1.employee_id=e1.employee_id
group by pay_month, e1.department_id) dept_avg
left join
(select left(s2.pay_date, 7) as pay_month, avg(s2.amount) as c_avg
from salary s2
join employee e2 on s2.employee_id=e2.employee_id
group by pay_month) comp_avg
on dept_avg.pay_month=comp_avg.pay_month
order by dept_avg.pay_month desc, dept_avg.department_id
;
