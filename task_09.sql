-- creating database
create database sales;
use sales;
-- displaying the data
select * from `online sales data`;
-- structure of database table
describe `online sales data`;
-- total rows
select count(*) from `online sales data`;
-- checking null values
select * from `online sales data` 
where `Transaction ID` is null;
-- checking duplicate values
select `Transaction ID`,count(*) from `online sales data`
group by `Transaction ID`
having count(*)>1;
-- converting from string to date format
select str_to_date(Date,'%m/%d/%Y') as parsed_date from `online sales data` limit 20;
### alter table `online sales data` add column parse_date date;
UPDATE `online sales data` 
SET parse_date = str_to_date(`Date`,'%m/%d/%Y');
-- Month wise total sales
select date_format(parse_date,'%Y/%m') as Sales_Month,round(sum(`Total Revenue`),2) Month_wise_sales from `online sales data`
group by Sales_Month
order by Sales_Month;
-- Total orders and avg units sold
select date_format(parse_date,'%Y/%m') as sales_month, count(distinct `Transaction ID`) as total_orders, avg(`Units Sold`) from `online sales data`
group by date_format(parse_date,'%Y/%m')
order by sales_month;
-- monthly sales of each category
select `Product Category`,date_format(parse_date,'%Y-%m') as sale_month,sum(`Total Revenue`) from `online sales data`
group by `Product Category`,date_format(parse_date,'%Y-%m') 
order by sale_month,`Product Category`;
-- Top 3 selling category
select `Product Category`,round(sum(`Total Revenue`),2) from `online sales data`
group by `Product Category`
order by sum(`Total Revenue`) desc limit 3;
-- Monthly sales trend of Top 3 selling category 
select `Product Category`,extract(month from parse_date), sum(`Total Revenue`) from `online sales data`
where `Product Category` in ('Electronics', 'Home Appliances', 'Sports')
group by `Product Category`,extract(month from parse_date)
order by extract(month from parse_date) asc,sum(`Total Revenue`) desc;
-- Top selling category of each month
with top_category_monthwise as (select `Product Category`,extract(month from parse_date) as sales_month, round(sum(`Total Revenue`),2) as Revenue_by_category, dense_rank() over (partition by extract(month from parse_date) order by sum(`Total Revenue`) desc) as sales_rank from `online sales data`
group by `Product Category`,sales_month
order by sales_month)
select * from top_category_monthwise
where sales_rank=1;
-- least sold category 
with top_category_monthwise as (select `Product Category`,extract(month from parse_date) as sales_month, sum(`Total Revenue`) as Revenue_by_category, dense_rank() over (partition by extract(month from parse_date) order by sum(`Total Revenue`) desc) as sales_rank from `online sales data`
group by `Product Category`,sales_month
order by sales_month)
select * from top_category_monthwise
where sales_rank=6;
-- top selling category month wise (in quantity)
with top_category_monthwise as (select `Product Category`,extract(month from parse_date) as sales_month, sum(`Units Sold`) as Revenue_by_category, dense_rank() over (partition by extract(month from parse_date) order by sum(`Units Sold`) desc) as quantity_rank from `online sales data`
group by `Product Category`,sales_month
order by sales_month)
select * from top_category_monthwise
where quantity_rank=1;
-- Total orders month wise
select count(`Transaction ID`) as Total_orders, date_format(parse_date,'%Y/%m') as Month from `online sales data`
group by date_format(parse_date,'%Y/%m');

-- top_selling_product_per_month
with top_selling_product_per_month as (select `Product Name`,extract(month from parse_date) as sales_month,sum(`Total Revenue`) as Revenue, dense_rank() over (partition by extract(month from parse_date) order by sum(`Total Revenue`) desc) as Product_Rank from `online sales data`
group by `Product Name`,extract(month from parse_date)
order by sales_month)
select * from top_selling_product_per_month
where Product_Rank=1;
-- Region wise sales
select Region,round(sum(`Total Revenue`),2) as Revenue from `online sales data`
group by Region
order by Revenue desc;
-- monthly total sales by region
select date_format(parse_date,'%Y/%m') as Month, Region, round(sum(`Total Revenue`),2) as Revenue from `online sales data`
group by Month,Region
order by Month asc, Revenue desc;
-- payment method
select date_format(parse_date,'%Y/%m') as Month, `Payment Method`, count(`Transaction ID`) as Transaction_count from `online sales data`
group by Month,`Payment Method`
order by Month asc, Transaction_count  desc;
-- Avg order 
select date_format(parse_date,'%Y/%m')as Month,round(sum(`Total Revenue`)/count(distinct `Transaction ID`),2) as Avg_order from `online sales data`
group by date_format(parse_date,'%Y/%m')
order by Month;
-- avg unit price by category
select `Product Category`,round(sum(`Total Revenue`)/sum(`Units Sold`),2) as Avg_unit_price from `online sales data`
group by `Product Category`;
-- Region and payment method
select Region,`Payment Method`,count(`Transaction ID`) as Total_transaction from `online sales data`
group by Region,`Payment Method`
order by Total_transaction;
-- Region and product category
select Region,`Product Category`,round(sum(`Total Revenue`),2) as Total_Revenue from `online sales data`
group by Region,`Product Category`
order by Region,Total_Revenue desc;
-- Top 5 selling product by quantity
select `Product Name`,sum(`Units Sold`) as Quantity_sold from `online sales data`
group by `Product Name`
order by Quantity_sold desc limit 5;






