With 
    joined_table as ( select fabd.ad_date,fc.campaign_name, fabd.spend, fabd.impressions, fabd.reach, fabd.clicks, fabd.leads, fabd.value
                        from facebook_ads_basic_daily as fabd
                        join facebook_adset as fa 
                          on fabd.adset_id = fa.adset_id
                        join facebook_campaign as fc 
                          on fabd.campaign_id = fc.campaign_id),

    single_table as ( select ad_date, campaign_name, spend, impressions, reach, clicks, leads, value
                        from google_ads_basic_daily)

Select cte.ad_date, cte.campaign_name, Sum(spend) as sum_spend, Sum(impressions) as sum_impressions, 
Sum(clicks) as sum_clicks, Sum(Value) as sum_value
  from ( select ad_date, campaign_name, spend, impressions, reach, clicks, leads, value
             from joined_table
         union all
         select ad_date, campaign_name, spend, impressions, reach, clicks, leads, value
           from single_table) as cte
Group by  cte.ad_date, cte.campaign_name;