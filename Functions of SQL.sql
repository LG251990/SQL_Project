select ad_date, campaign_id, 
sum(spend) as total_spend, count(*),
sum(clicks) as total_clicks,
sum(impressions) as total_impressions,
sum(value) as total_value,
sum(spend)/sum(clicks) as CPC,
	   round(cast (sum(spend) as float4)/cast (sum(impressions) as float4)*1000) CPM,
	   round(cast (sum(clicks) as numeric) /cast (sum(impressions) as numeric) *100,2) as CPR,
	   round((cast(sum(value) as numeric) - cast (sum(spend)as numeric))/cast (sum(spend) as numeric) *100,2) as ROI
from facebook_ads_basic_daily
group by ad_date, campaign_id
having sum(clicks) > 0;

select * from 
(select campaign_id, sum(spend) total_spend, round((cast(sum(value) as numeric) - cast (sum(spend)as numeric))/cast (sum(spend) as numeric) *100,2) as ROI
from facebook_ads_basic_daily
group by campaign_id
having sum(spend)>500000) as aaa
order by aaa.roi desc;