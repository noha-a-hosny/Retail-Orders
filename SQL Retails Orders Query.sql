use depi




alter  table depi_data 
alter column 
    list_price int 


	alter  table depi_data 
alter column 
    cost_price int 

	alter  table depi_data 
alter column 
    quantity int 

	alter  table depi_data 
alter column 
   discount_percent int 


   alter  table depi_data 
alter column 
    order_id int  





   ------standardize data



use depi
select  distinct(Segment),count (segment)
from dbo.depi_data
group by Segment




select  distinct(Ship_Mode),count (Ship_Mode)
from dbo.depi_data
group by Ship_Mode


update dbo.depi_data
set Ship_Mode= null
where Ship_Mode= 'unknown' 

update dbo.depi_data
set Ship_Mode= null
where Ship_Mode= 'N/A' 


update dbo.depi_data
set Ship_Mode= null
where Ship_Mode= 'Not Available' 


select  distinct(Country),count (Country)
from dbo.depi_data
group by Country


select  distinct(City),count (City)
from dbo.depi_data
group by City,[Postal Code]
order by 1

select  distinct(Region),count (Region)
from dbo.depi_data
group by Region


select  distinct(State),count (State)
from dbo.depi_data
group by State







select  distinct(Category),count (Category)
from dbo.depi_data
group by Category

select  distinct(Sub_Category),count (Sub_Category)
from dbo.depi_data
group by Sub_Category
order by 1



-------checking duplicates

select *, row_number()over (partition by ship_mode,city,category,sub_category,segment,product_id,cost_price order by order_id)as rn
from depi_data

select *
from
 (
select row_number()over (partition by ship_mode,city,category,sub_category,segment,product_id,cost_price,list_price,quantity,order_id order by order_id)as rn
from depi_data
) as newtable
where rn >1
  

  ---no  duplicates


  -----------------------------------------------------------------------------------------------------------


  ------analysis





 

--categories and sub-categories






---Which product categories contribute the most to Total Revenues and Net Profit? 
---
----------Total Revenues = (List Price - (List Price * Discount Percentage / 100)) * Quantity
---and--- Total Profit = Total Revenue - (Cost Price * Quantity)



-------Total Revenues

SELECT
    SUM((list_price-(list_price*discount_percent/100))*Quantity) AS Total_Revenues
from depi_data



--------Total Profit


select  SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data



	------------------------------Which product categories contribute the most and least to Total Revenues--------------------
	
	
	SELECT  top (1)category,
    SUM((list_price-(list_price*discount_percent/100))*quantity) AS Total_Revenues
from depi_data
group by (Category)
order by Total_Revenues desc


SELECT  top (1)category,
    SUM((list_price-(list_price*discount_percent/100))*quantity) AS Total_Revenues
from depi_data
group by (Category)
order by Total_Revenues asc





-------Technology category contribute the most to Total Revenues
-------Office Supplies category contribute the least to Total Revenues



SELECT category,
    SUM((list_price-(list_price*discount_percent/100))*quantity) AS Total_Revenues
from depi_data
group by rollup (Category )



--------------------------------Which product subcategories contribute the most and least to Total Revenues--------------


SELECT  top(1)Sub_Category,
    SUM((list_price-(list_price*discount_percent/100))*Quantity) AS Total_Revenues
from depi_data
group by Sub_Category
order by Total_Revenues desc



SELECT  top(1)Sub_Category,
    SUM((list_price-(list_price*discount_percent/100))*Quantity) AS Total_Revenues
from depi_data
group by Sub_Category
order by Total_Revenues asc




------chairs subcategory contribute the most to Total Revenues
------Fasteners subcategory contribute the least to Total Revenues



-------------------------------Which product subcategories contribute the most and least to Total profit-------------


SELECT top (1)Sub_Category,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by Sub_Category
order by total_profit desc


SELECT top (1)Sub_Category,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by Sub_Category
order by total_profit asc


------Chairs subcategory contribute the most to Total profit
-----Fasteners subcategory contribute the least to Total profit




----------------------Which product categories contribute the most and least to Total profit----------

SELECT  Top(1)Category,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by Category
order by total_profit desc



SELECT  Top(1)Category,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by Category
order by total_profit asc





-------Technology category contribute the most to Total profit

-------Office Supplies category contribute the least to Total profit





-----What are top 5 selling Sub Categories?  (drive the most Total Revenues / Net Profit )


----by total profit

SELECT  top(5)Sub_Category,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by sub_Category
order by total_profit desc


SELECT  top(5)Sub_Category,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by sub_Category
order by total_profit asc


--Chairs,Phones,Binders,Tables,and Storage drive the most Total profit
---Fasteners,Labels,Envelopes,Art and Supplies drive the least Total profit








-----by total revenues


SELECT  top (5)Sub_Category,
    SUM((list_price-(list_price*discount_percent/100))*Quantity) AS Total_Revenues
from depi_data
group by Sub_Category
order by  Total_Revenues desc


SELECT  top (5)Sub_Category,
    SUM((list_price-(list_price*discount_percent/100))*Quantity) AS Total_Revenues
from depi_data
group by Sub_Category
order by  Total_Revenues asc


-------Chairs,Phones,Binders,Tables,and Storage drive the most Total revenues
----Fasteners,Labels,Envelopes,Art,and Supplies drive the least Total revenues











--What are the overall Revenues / Net Profit trend over time? 


-----by total revenues over time

select year(order_date)as year,month(Order_Date)as month, SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data
group by MONTH(Order_Date),YEAR(Order_Date)
order by 1,2



select year(Order_Date), SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data
group by year(Order_Date)
order by 1



-----by total profit


select year(order_date)as year,month(Order_Date)as month,SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data
group by MONTH(Order_Date),YEAR(Order_Date)
order by 1,2















----------------------------------customer segments-------------

-----What is the distribution of customer segments?

select top(1)segment ,count(*)
from depi_data
group by Segment
order by 2 desc

select segment ,count(*)
from depi_data
group by Segment
order by 2 desc



----Consumer has the most of the distribution of customer segments
---Home Office has the least of the distribution of customer segments


-----Which customer segment drive the most Total Revenues / Net Profit? 


---by total profit

SELECT top(1)Segment,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by Segment
order by 2 desc




SELECT Segment,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by Segment
order by 2 desc

--consumer segment drive the most total profit
----Home Office segment drive the least total profit




---2-by total revenue

SELECT top(1) Segment,
    SUM((list_price-(list_price*discount_percent/100))*Quantity) AS Total_Revenues
from depi_data
group by Segment
order by 2 desc
  
  --consumer segment drive the most total revenue






----What segment place the highest number of orders? 



SELECT TOP(1) Segment, COUNT(DISTINCT order_id)
FROM depi_data
GROUP BY Segment
order by 2 desc
  
    --consumer segment has  the highest number of orders





	------------What is the average order size for each segment?

	SELECT
    Segment,
    AVG(quantity * List_Price) AS average_order_size
FROM
    depi_data
GROUP BY
    Segment;









	-------------------------region-----------

	-----What are Total Revenues / total Profit for different regions? 



	---by total revenues
	SELECT  Region,
    SUM((list_price-(list_price*discount_percent/100))*quantity) AS Total_Revenues
from depi_data
group by Region
order by 2 desc


  

  ----by total profit
  SELECT Region,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by Region
order by 2 desc






---------What are the Top 10 states (or cities) most contributing to sales (or Revenues) / Net Profit? 



-----by total revenues
SELECT top(10) State,
    SUM((list_price-(list_price*discount_percent/100))*quantity) AS Total_Revenues
from depi_data
group by State
order by 2 desc



---by total profit


SELECT top(10) State,
    
    SUM((list_price-(list_price*discount_percent/100))*quantity)-sum(cost_price*quantity) as total_profit
from depi_data

group by State
order by 2 desc



-----What are the bottom 10 states (or cities) least contributing to sales? 



SELECT top(10) State,
    SUM((list_price-(list_price*discount_percent/100))*quantity) AS Total_Revenues
from depi_data
group by State
order by Total_Revenues asc




-------What is the most demanded sub-category in each region? 


SELECT sub_category,Region, SUM(quantity) AS total_quantity
FROM
    depi_data
GROUP BY
    region, sub_category
ORDER BY
     region,total_quantity DESC;


	---- Binders is the most demanded sub-category in each region
	 


	
	-------------------------shipping modes
	--What is the distribution of shipping modes?

	select Ship_Mode ,count(*)
from depi_data
group by Ship_Mode
order by 2 desc

---Standard Class has the most of  distribution of shipping modes
----Same Day has the least of  distribution of shipping modes



------What is the distribution of categories for different shipping modes?


	select category,Ship_Mode ,count(*)
from depi_data
group by Ship_Mode,Category
order by 3 desc


-------What shipping mode achieved highest sales? 

select top (1)ship_mode, SUM((list_price-(list_price*discount_percent/100))*Quantity) AS Total_Revenues
from depi_data
group by Ship_Mode
order by 2 desc

-----Standard Class  achieved highest sales



--------------What shipping modes sold the most products?

SELECT
    Ship_Mode,
    SUM(quantity) AS total_quantity
FROM
    depi_data
GROUP BY
    Ship_Mode
ORDER BY
    total_quantity DESC

	----Standard Class sold the most products

