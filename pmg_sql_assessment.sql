-- creating schema for store_revenue
create table store_revenue (date date, brand_id int, store_location varchar(250), revenue float);
-- loading the records from csv
COPY store_revenue
FROM '/Users/rohan/Downloads/store_revenue.csv'
DELIMITER ','
CSV HEADER;

-- creating the schema for marketing_data
create table marketing_data (  date date, geo varchar(2), impressions float, clicks float );
-- loading the mrecords from csv
COPY marketing_data
FROM '/Users/rohan/Downloads/marketing_data.csv'
DELIMITER ','
CSV HEADER;

-- *  Question #1
-- Generate a query to get the sum of the clicks of the marketing data
select sum(m.clicks) as sum_of_clicks from marketing_data m;

-- *  Question #2
--  Generate a query to gather the sum of revenue by store_location from the store_revenue table
select s.store_location, sum(s.revenue) as revenue from store_revenue s group by s.store_location;

-- *  Question #3
--  Merge these two datasets so we can see impressions, clicks, and revenue together by date and geo.
--  Please ensure all records from each table are accounted for.

select distinct s.date, SUBSTRING(s.store_location, 15),AVG(m.impressions)::float as impressions, AVG(m.clicks)::float as clicks, SUM(s.revenue) as revenue from store_revenue s 
left outer join marketing_data m
on m.date = s.date and m.geo = SUBSTRING(s.store_location, 15) group by s.store_location, s.date
UNION
select distinct m.date, m.geo,AVG(m.impressions)::float as impressions, AVG(m.clicks)::float as clicks, SUM(s.revenue) as revenue from store_revenue s 
right outer join marketing_data m
on m.date = s.date and m.geo = SUBSTRING(s.store_location, 15) group by m.geo, m.date order by 1;
--[NOTE: since, all the records from each table are needed, there are some records in the store_revenue table for which there is no data in the marketing_data and vice versa, hence UNION operation performed to fetch all records, and display as NULL for no data fields]


-- * Question #4
--  In your opinion, what is the most efficient store and why?
with click_revenue as (
select distinct m.date, m.geo,AVG(m.impressions)::float as impressions, AVG(m.clicks)::float as clicks, SUM(s.revenue) as revenue from store_revenue s 
join marketing_data m
on m.date = s.date and m.geo = SUBSTRING(s.store_location, 15) group by m.geo, m.date)
select c.geo, SUM(c.revenue)/(SUM(c.clicks)/SUM(c.impressions)) as revenue_per_click_through, SUM(c.clicks)/SUM(c.impressions) as click_through_rate from click_revenue c  group by c.geo order by 2 desc;
--[NOTE: the query above ranks the most efficient store. Since clicks_per_impression_rate * success_rate_of_click is proportional to revenue, we calculate  success_rate_of_click =  revenue/clicks_per_impression_rate, with cost per product being constant ]



-- * Question #5 (Challenge)
--  Generate a query to rank in order the top 10 revenue producing states
select SUBSTRING(s.store_location,15) as states, SUM(s.revenue)::float as revenue from store_revenue s
group by s.store_location order by 2 desc limit 10;

