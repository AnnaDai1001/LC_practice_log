# spending table -> group by date, platform(changed to m, d, both), total amount, num of users
# 1. get the count for each of the transformed platform
# 2. add the other columns needed

SELECT temp2.spend_date, temp2.platform, IFNULL(temp3.total_amount,0) AS total_amount, IFNULL(temp3.total_users,0) AS total_users
FROM
(
  SELECT DISTINCT spend_date, 'both' as platform FROM spending_table UNION ALL
  SELECT DISTINCT spend_date, 'mobile' as platform FROM spending_table UNION ALL
  SELECT DISTINCT spend_date, 'desktop' as platform FROM spending_table
) temp2 
LEFT JOIN
(
  SELECT spend_date, platform, SUM(amount) as total_amount, COUNT(user_id) as total_users
  FROM
  (
    SELECT spend_date, user_id, SUM(amount) as amount,
    CASE WHEN COUNT(DISTINCT platform)>1 THEN 'both' ELSE platform END as platform
    FROM spending_table
    GROUP BY spend_date, user_id
  ) temp1
  GROUP BY spend_date, platform
) temp3
ON temp2.spend_date=temp3.spend_date AND temp2.platform=temp3.platform
