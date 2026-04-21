create database CS1SQL
--Q1.
select count(*) from Transactions$

select top 1 * from Transactions$
select top 1 * from Customer$
select top 1 * from prod_cat_info$

--Q2.Transactions that have a return.
select count(transaction_id)  from Transactions$ where Qty<0;

--Q3. 
UPDATE Transactions$
SET tran_date = CONVERT(DATE, tran_date,105)
ALTER TABLE Transactions$
ALTER COLUMN tran_date DATE;

--Q4.Time range of data
select DATEDIFF(year,min(tran_date),max(tran_date))  year ,
 DATEDIFF(month,min(tran_date),max(tran_date))  months ,
 DATEDIFF(DAY,min(tran_date),max(tran_date))  days from Transactions$ ;

 --Q5.DIY sub-cat belong to what cat ?
 select prod_cat from prod_cat_info$ where prod_subcat='DIY';

 --Q6.Which channel is most used for trans?
 select top 1  store_type, count(store_type) cnt from Transactions$ group by
 Store_type order by cnt desc;

 --Q7.Male and female cust ?
 select Gender ,count(Gender) from Customer$ 
 where gender is not null group by Gender ;

 --Q8.City with max cust and how many ?
 select top 1  count(customer_id)  cnt , city_code from Customer$
 group by city_code order by cnt desc;

 --Q9. no of SUB CAT- under books cat ?
 select prod_cat , count(prod_subcat) sub_cat_number
 from prod_cat_info$ 
 where prod_cat='Books'
 group by prod_cat  ;

 --Q5.Max quantity of products ever ordered ?
 select top 1  prod_cat, sum (Qty) cnt  from
 Transactions$ a join prod_cat_info$ b on a.prod_subcat_code=b.prod_sub_cat_code 
 and a.prod_cat_code=b.prod_cat_code where qty>1
 group by prod_cat  order by cnt desc ;

 --Q6.Revenue in Electronics and Books cat ?
 select   sum(total_amt)  Revenue  from  Transactions$ a 
 join prod_cat_info$ b
 on a.prod_subcat_code=b.prod_sub_cat_code
 and a.prod_cat_code=b.prod_cat_code where
 prod_cat in ('Electronics','Books');

 --Q7.How many customers  have transcations >10 , excluding returns ?
 select count(*)  Total_customers
 from (
 select cust_id   from
 Transactions$ where Qty>0  group by cust_id 
 having count(transaction_id)>10 ) l ;

 --Q8.Revenue from electronics and clothing from flagship stores ?
 SELECT sum(total_amt)  revenue  from Transactions$ a join prod_cat_info$ b on
 a.prod_subcat_code=b.prod_sub_cat_code  
 and a.prod_cat_code=b.prod_cat_code where prod_cat in 
 ('Electronics' ,'Clothing') 
 and store_type='Flagship store' ;

 --Q9.Revenue from male in  electronics cat ,total revenue by prod_sub_cat ?

select round(sum(total_amt),3)  Revenue_by_male , prod_subcat  from Transactions$   a join prod_cat_info$ b
 on a.prod_subcat_code=b.prod_sub_cat_code join Customer$  c on  a.cust_id=c.customer_Id
 and a.prod_cat_code=b.prod_cat_code where  Gender ='M' and prod_cat='Electronics' group by prod_subcat;

--Q10.Percent of Sales and Returns by prod sub-cat , display only top 5 sub-cat in terms of Sale ?

select prod_subcat , sum( case when Qty>0 then Qty else 0 end )*100 / (  select sum(QTY)  from Transactions$ where Qty>0    ) percentage_sales ,
sum( case when Qty<0 then Qty else 0 end ) *100/ (  select sum( Qty )   from Transactions$ where Qty<0 ) return_percentage
from Transactions$  q  join prod_cat_info$ w on
q.prod_subcat_code=w.prod_sub_cat_code
and q.prod_cat_code=w.prod_cat_code
where prod_subcat in 
(
select top 5 prod_subcat from Transactions$ f
join prod_cat_info$ g on
f.prod_subcat_code=g.prod_sub_cat_code
and f.prod_cat_code=g.prod_cat_code
where Qty>1
group by prod_subcat order by sum(Qty) desc )
group by prod_subcat order by percentage_sales desc ;

--Q11.Customer age 25-35 ,net revenue by them in last 30 days from max tran date ?
-----If you were trying to filter by something that’s not in the GROUP BY or not an aggregate function, you'd get an error.

update  Customer$
set DOB=convert(date,DOB,105) 
alter table  Customer$
alter column DOB DATE;

select sum(revenue) net_revenue from
(
select  datediff(year, DOB ,max(tran_date)) age , cust_id,
sum(total_amt)  revenue 
from Transactions$ v join Customer$ s  on v.cust_id=s.customer_Id
where tran_date>=DATEADD(day,-30,(select max(tran_date) FROM Transactions$))
group by cust_id ,DOB having datediff(year, DOB ,max(tran_date)) between 25 and 35) n ;


--Q12.Which product category has seen the max value of returns in the last 3 month of transactions ?
select  top 1 abs(sum(total_amt)),  prod_cat from Transactions$ a join Customer$ b 
on a.cust_id=b.customer_Id join prod_cat_info$ c
on a.prod_cat_code=c.prod_cat_code  where Qty<0 and 
tran_date>=DATEADD(month,-3,(select(max(tran_date)) from Transactions$))
group by prod_cat order by abs (sum(total_amt) )desc;


--Q13.Which store_type sells the most quantity and has max_amount  of sales  ?
select  top 1 store_type ,round(sum(total_amt),2) SUM ,  sum(Qty) QUANTITY
from Transactions$  where qty>1 group by 
Store_type order by  SUM desc , QUANTITY desc;

--Q14.Categories for which average revenue is above the overall total average revenue ?
select prod_cat from Transactions$  x join  prod_cat_info$ y on 
x.prod_subcat_code=y.prod_sub_cat_code  and x.prod_cat_code=y.prod_cat_code where Qty>0
group by prod_cat  having AVG(total_amt) > (select avg(total_amt) from Transactions$) ;


--Q15.
select prod_subcat, avg(total_amt) average_revenue  ,sum(total_amt) total_revenue from   Transactions$ a 
join prod_cat_info$ b on
a.prod_subcat_code=b.prod_sub_cat_code   and b.prod_cat_code=a.prod_cat_code where prod_cat
in (
select  top  5 prod_cat from Transactions$ a join prod_cat_info$ b on
a.prod_subcat_code=b.prod_sub_cat_code   and b.prod_cat_code=a.prod_cat_code 
group by prod_cat order by sum(qty) desc) group by  prod_subcat;



--Q13.   when store can be different.
WITH a AS ( select top 1  store_type ,sum(total_amt) revenue from Transactions$ where qty>1 group by Store_type order by revenue desc ),
b AS ( select top 1  store_type ,sum(Qty) valuee from Transactions$ where qty>1 group by Store_type   order by valuee desc ) 

select a.store_type , a.revenue ,b.store_type ,b.valuee from a join b on 1=1 ;


select  top 1 store_type ,round(sum(total_amt),2) SUM ,  sum(Qty) QUANTITY
from Transactions$  where qty>1 group by 
Store_type order by  SUM desc , QUANTITY desc;


select top 1 * from Transactions$
select top 1 * from Customer$
select top 1 * from prod_cat_info$

--Q10
SELECT  PROD_SUBCAT , SUM ( CASE WHEN QTY>0 THEN TOTAL_AMT ELSE 0  END) *100 / ( SELECT SUM(TOTAL_AMT) FROM Transactions$ WHERE Qty>0 ) SALESPERCENTAGE ,
SUM ( CASE WHEN QTY<0 THEN TOTAL_AMT ELSE 0  END)*100 / ( SELECT SUM(TOTAL_AMT) FROM Transactions$ WHERE Qty<0 ) RETURNPERCENT
FROM Transactions$ A JOIN prod_cat_info$ B ON 
A.prod_subcat_code=B.prod_sub_cat_code  AND A.prod_cat_code=B.prod_cat_code
WHERE PROD_SUBCAT
IN(
SELECT TOP 5 prod_subcat  FROM Transactions$ A JOIN prod_cat_info$ B ON 
A.prod_subcat_code=B.prod_sub_cat_code  AND A.prod_cat_code=B.prod_cat_code WHERE QTY>0
GROUP BY prod_subcat  ORDER BY SUM(TOTAL_AMT) DESC ) 

GROUP BY PROD_SUBCAT ;


--Q11
SELECT  SUM(CNT) FROM
(
SELECT SUM(TOTAL_AMT)  CNT  FROM Transactions$  A JOIN prod_cat_info$ B ON
A.prod_subcat_code=B.prod_sub_cat_code AND A.prod_cat_code=B.prod_cat_code  
JOIN Customer$ C ON C.customer_Id=A.cust_id
WHERE TRAN_DATE>=DATEADD(DAY,-30,(SELECT MAX(TRAN_DATE) FROM Transactions$))
GROUP BY DOB
HAVING DATEDIFF(YEAR,DOB,MAX(TRAN_DATE)) BETWEEN 25 AND 35 ) S ;

--Q12
SELECT  TOP 1  PROD_CAT  , ABS(SUM(TOTAL_AMT)) 
RETURN_VALUE
FROM prod_cat_info$ A 
JOIN Transactions$ B ON 
A.prod_sub_cat_code=B.prod_subcat_code 
AND A.prod_cat_code=B.prod_cat_code  WHERE QTY<1 AND 
tran_date>=DATEADD(MONTH,-3,(SELECT MAX(TRAN_DATE) FROM TRANSACTIONS$))
GROUP BY prod_cat
ORDER BY ABS(SUM(TOTAL_AMT)) DESC;

--Q13
WITH A  AS (
SELECT  TOP 1 STORE_TYPE , SUM(QTY)CNT FROM
Transactions$ WHERE QTY>0
GROUP BY Store_type ORDER BY  CNT DESC) ,
B AS (
SELECT  TOP 1 STORE_TYPE , SUM(TOTAL_AMT) 
CNT FROM Transactions$ WHERE QTY>0
GROUP BY Store_type ORDER BY  CNT DESC)

SELECT A.STORE_TYPE , B.STORE_TYPE FROM A JOIN B ON 1=1 ;

--Q14
SELECT PROD_CAT  FROM prod_cat_info$ A JOIN
Transactions$ B ON A.prod_cat_code=B.prod_cat_code
AND A.prod_sub_cat_code=B.prod_subcat_code WHERE QTY>0
GROUP BY prod_cat HAVING  AVG(TOTAL_AMT) >
(SELECT AVG(TOTAL_AMT) FROM TRANSACTIONS$ ) ;

--Q15

SELECT PROD_SUBCAT ,AVG(TOTAL_AMT)  AVERAGE , SUM(TOTAL_AMT)
TOTAL_REVENUE FROM prod_cat_info$ A JOIN
Transactions$ B ON A.prod_cat_code=B.prod_cat_code
AND A.prod_sub_cat_code=B.prod_subcat_code 
WHERE  QTY>0 AND  PROD_CAT 
IN(
SELECT TOP 5  prod_cat
FROM prod_cat_info$ A JOIN
Transactions$ B ON A.prod_cat_code=B.prod_cat_code
AND A.prod_sub_cat_code=B.prod_subcat_code WHERE QTY>0
GROUP BY prod_cat ORDER BY SUM(QTY) DESC)
GROUP BY prod_subcat ;