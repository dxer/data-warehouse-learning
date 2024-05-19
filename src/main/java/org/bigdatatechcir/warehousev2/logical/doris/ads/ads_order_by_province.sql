INSERT INTO ads.ads_order_by_province(dt, recent_days, province_id, province_name, area_code, iso_code, iso_code_3166_2, order_count, order_total_amount)
select * from ads.ads_order_by_province
union
select
    '2020-06-14' dt,
    1 recent_days,
    province_id,
    province_name,
    area_code,
    iso_code,
    iso_3166_2,
    order_count_1d,
    order_total_amount_1d
from dws.dws_trade_province_order_1d
union
select
    '2020-06-14' dt,
    recent_days,
    province_id,
    province_name,
    area_code,
    iso_code,
    iso_3166_2,
    sum(order_count),
    sum(order_total_amount)
from
    (
        select
            recent_days,
            province_id,
            province_name,
            area_code,
            iso_code,
            iso_3166_2,
            case recent_days
                when 7 then order_count_7d
                when 30 then order_count_30d
                end order_count,
            case recent_days
                when 7 then order_total_amount_7d
                when 30 then order_total_amount_30d
                end order_total_amount
        from dws.dws_trade_province_order_nd lateral view explode(array(7,30)) tmp as recent_days
    )t1
group by recent_days,province_id,province_name,area_code,iso_code,iso_3166_2;