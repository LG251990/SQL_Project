select*from facebook_ads_basic_daily;
select*from facebook_adset;
select*from facebook_campaign;
select*from google_ads_basic_daily;

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
           from CTE_2)
           
           
          select ad_date, campaign_name, case when substring(lower(url_parameters) , 'utm_campaign=([^&#$]+)')='nan'then null else lower(url_parameters) end as case_url,
          --lower(url_parameters),substring(lower(url_parameters) , 'utm_campaign=([^&#$]+)') as url_parameters,
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
          group by ad_date, campaign_name, url_parameters
          
          
          
          
          
         
          
          
          
          
          
     
   
   
 



