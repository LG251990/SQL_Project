with 
     
CTE_1 as (
  select fabd.ad_date, fabd.url_parameters, fabd.spend, fabd.impressions, fabd.reach, fabd.clicks, fabd.leads, fabd.value, fc.campaign_name  
      from facebook_ads_basic_daily as fabd  
   join facebook_adset as fa
     on fabd.adset_id=fa.adset_id 
   join facebook_campaign as fc
     on fabd.campaign_id=fc.campaign_id),
     
     CTE_2 as(
          select ad_date, url_parameters, spend, impressions, reach, clicks, leads, value, campaign_name  
      from google_ads_basic_daily),
      
     
      CTE_3 as(
      
       select ad_date, url_parameters, spend, impressions, reach, clicks, leads, value, campaign_name
      from CTE_1
     union all
         select ad_date, url_parameters, spend, impressions, reach, clicks, leads, value, campaign_name
           from CTE_2),
      CTE_4 as (    
           select /*ad_date,*/ date_trunc('month', ad_date) as ad_month, /*ad_date - interval '1 month' as previous_month,*/ campaign_name, 
           Sum(coalesce (spend,0)) as spend, 
              Sum(coalesce (impressions,0)) as impressions, 
              Sum(coalesce (reach,0))as reach, 
              Sum(coalesce(clicks,0)) as clicks, 
              Sum(coalesce(leads,0))as leads, 
              Sum(coalesce(value,0))as value,
              case when sum(impressions) =0 then null else 
              round(cast (sum(spend) as float4)/cast (sum(impressions) as float4)*1000) 
              end as CPM,
              case when sum(impressions)=0 then null else
              round(cast (sum(clicks) as numeric) /cast (sum(impressions) as numeric) *100,2) 
              end as CPR,
              case when sum(clicks)=0 then null else 
              sum(spend)/sum(clicks)
              end as CPC,
              case when sum(spend)=0 then null else
              round((cast(sum(value) as numeric) - cast (sum(spend)as numeric))/cast (sum(spend) as numeric) *100,2)
              end as ROI
              
              
      from CTE_3
      group by date_trunc('month', ad_date), campaign_name
      order by date_trunc('month', ad_date))
      
      
      
      
     select cte_4.ad_month, cte_4.campaign_name,
          cte_4.cpm current_month_CPM, lag(cte_4.cpm) 
    over (partition by campaign_name order by cte_4.ad_month) prev_month_cpm, 
    
    case when lag(cte_4.cpm)over (partition by campaign_name order by cte_4.ad_month) !=0 then 
     ((cte_4.cpm - lag(cte_4.cpm) over (partition by campaign_name order by cte_4.ad_month))/lag(cte_4.cpm)
     over (partition by campaign_name order by cte_4.ad_month))*100 end  cpm_growth,
    
  
          cte_4.cpr current_month_CPR, lag(cte_4.cpr) 
     over (partition by campaign_name order by cte_4.ad_month) prev_month_cpr, 
     
     case when lag(cte_4.cpr)over (partition by campaign_name order by cte_4.ad_month) !=0 then 
     ((cte_4.cpr - lag(cte_4.cpr) 
     over (partition by campaign_name order by cte_4.ad_month))/lag(cte_4.cpr)
     over (partition by campaign_name order by cte_4.ad_month))*100 end cpr_growth, 
     
  
    
          cte_4.roi current_month_roi, lag(cte_4.roi) 
     over (partition by campaign_name order by cte_4.ad_month) prev_month_roi, 
     
     case when lag(cte_4.roi)over (partition by campaign_name order by cte_4.ad_month) !=0 then 
     ((cte_4.roi - lag(cte_4.roi) 
     over (partition by campaign_name order by cte_4.ad_month))/lag(cte_4.roi)
     over (partition by campaign_name order by cte_4.ad_month))*100 end roi_growth 
     
     from CTE_4 
     
    