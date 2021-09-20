> Table google_gmail_emails: id | from_user | to_user | day
> Email activity rank is defined by the total number of emails sent. The user with the highest number of emails sent will have a rank of 1, and so on. Output the user, total emails, and their activity rank. Order records by the total number of emails in descending order. Sort users with same number in alphabetic order. 
  
  ```
  select from_user, cnt_email, rank() over(order by cnt_email desc, from_user) as rk #can also use row_number()
  from
  (select from_user, count(*) as cnt_email
  from google_gmail_emails
  group by 1)tmp
  ```
