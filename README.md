# SQL - Assessment
Data Provided: store_revenue and marketing_data

<b>Question 1:</b><br>
select sum(m.clicks) as sum_of_clicks from marketing_data m;

<b>Question 2:</b><br>
select s.store_location, sum(s.revenue) as revenue from store_revenue s group by s.store_location order by 2 desc;

<b>Question 3:</b><br>
select distinct s.date, SUBSTRING(s.store_location, 15),AVG(m.impressions)::float as impressions, AVG(m.clicks)::float as clicks, SUM(s.revenue) as revenue from store_revenue s 
left outer join marketing_data m
on m.date = s.date and m.geo = SUBSTRING(s.store_location, 15) group by s.store_location, s.date
UNION
select distinct m.date, m.geo,AVG(m.impressions)::float as impressions, AVG(m.clicks)::float as clicks, SUM(s.revenue) as revenue from store_revenue s 
right outer join marketing_data m
on m.date = s.date and m.geo = SUBSTRING(s.store_location, 15) group by m.geo, m.date order by 1;

<b>Question 4:</b><br>
with click_revenue as (
select distinct m.date, m.geo,AVG(m.impressions)::float as impressions, AVG(m.clicks)::float as clicks, SUM(s.revenue) as revenue from store_revenue s 
join marketing_data m
on m.date = s.date and m.geo = SUBSTRING(s.store_location, 15) group by m.geo, m.date)
select c.geo, SUM(c.revenue)/(SUM(c.clicks)/SUM(c.impressions)) as revenue_per_click_through, SUM(c.clicks)/SUM(c.impressions) as click_through_rate from click_revenue c  group by c.geo order by 2 desc;

<b>Question 5:</b><br>
select SUBSTRING(s.store_location,15) as states, SUM(s.revenue)::float as revenue from store_revenue s
group by s.store_location order by 2 desc limit 10;



