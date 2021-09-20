> A post with all the LC database questions: https://zhuanlan.zhihu.com/p/265247944

> A post summarized the test points: https://www.1point3acres.com/bbs/thread-706788-1-1.html (below are my notes from it)

- [x] rank, dense_rank:
 > rank 不能直接命名成rank，必须加双引号as "rank"
 > **不能直接用where，要在外面套用一层select 再用where**
 > 区别rank 和dense_rank, dense 连续编号
- [x] distinct: ``` count(distinct x); distinct a,b ```
- [ ] join的用法：on可以有多个条件用and连接；using(id)?; 见leetcode1440
- [x] function: begin()里不加分号
- [x] aggregate function: 可直接用于having中，但不能直接在where中
- [x] null相关：isnull ifnull nullif 区别：isnull(xxx) 返回0或1； ifnull(e1, e2)   如果e1是null返回e2； nullif(e1,e2)比较e1和e2是否相等，如果等返回null，不等返回e1
- [ ]  
