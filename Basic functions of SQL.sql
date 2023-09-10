select ad_date, campaign_id , 
sum(spend) as total_spend, count(*),
sum(clicks) as total_clicks,
sum(impressions) as total_impressions,
sum(value) as total_value
from facebook_ads_basic_daily 
group by ad_date, campaign_id  

select ad_date, campaign_id, sum(spend)/sum(clicks) as CPC 
from facebook_ads_basic_daily
group by ad_date, campaign_id
having sum(clicks) > 0;

select ad_date, campaign_id,  
round(cast (sum(spend) as float4)/cast (sum(impressions) as float4)*1000) CPM
from facebook_ads_basic_daily
group by ad_date, campaign_id
having sum(impressions) > 0 
order by ad_date asc;

select ad_date, campaign_id, round(cast (sum(clicks) as numeric) /cast (sum(impressions) as numeric) *100,2) as CPR
from facebook_ads_basic_daily
group by ad_date, campaign_id
having sum(impressions) > 0
order by ad_date asc;

select ad_date, campaign_id, round((cast(sum(value) as numeric) - cast (sum(spend)as numeric))/cast (sum(spend) as numeric) *100,2) as ROI
from facebook_ads_basic_daily
group by ad_date, campaign_id
having sum(spend) > 0
order by ad_date asc;


select* from facebook_ads_basic_daily