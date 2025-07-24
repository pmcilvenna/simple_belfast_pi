-- SQL Query Analysis
-- This query appears to be analyzing supply-side advertising data with fraud detection metrics

SELECT
    sum(revenue) AS revenue,
    sum(total_requests) AS total_requests,
    sum(whiteops_attempts_delayed) AS whiteops_attempts_delayed,
    sum(whiteops_blocked) AS whiteops_blocked,
    sum(whiteops_blocked_delayed) AS whiteops_blocked_delayed,
    sum(whiteops_blocked_without_delay) AS whiteops_blocked_without_delay,
    date_trunc('day', ymdh) AS ymdh
FROM
    (
        SELECT
            sum(revenue) AS revenue,
            -- Complex CASE statement for calculating total requests based on supply_router_id
            sum(
                case
                    when supply_router_id != 0 THEN routed_wo_missed_requests + routed_pm_missed_requests + routed_missed_requests + usable_requests
                    ELSE usable_requests + blocked_requests + whiteops_blocked + prebid_blocked_internal_domain + prebid_blocked_internal_ip + prebid_blocked_internal_wo_cache + ss_protected_media_prebid_susp + ss_protected_media_prebid_fraud + prebid_blocked_internal_pm_cache_susp + prebid_blocked_internal_pm_cache_fraud
                END
            ) AS total_requests,
            
            -- Time-based filtering for delayed metrics (72 hours before '2025-06-20 10:00:00')
            sum(
                case
                    when ymdh < dateadd(hour, -72, '2025-06-20 10:00:00') then whiteops_attempts
                    else 0
                end
            ) AS whiteops_attempts_delayed,
            sum(
                case
                    when ymdh < dateadd(hour, -72, '2025-06-20 10:00:00') then whiteops_blocked + prebid_blocked_internal_wo_cache
                    else 0
                end
            ) AS whiteops_blocked,
            sum(
                case
                    when ymdh < dateadd(hour, -72, '2025-06-20 10:00:00') then whiteops_blocked + prebid_blocked_internal_wo_cache
                    else 0
                end
            ) AS whiteops_blocked_delayed,
            sum(
                whiteops_blocked + prebid_blocked_internal_wo_cache
            ) AS whiteops_blocked_without_delay,
            agg_table.key_values ['channel_id'] AS "key_channel_id",
            date_trunc('day', convert_timezone('UTC', 'UTC', ymdh)) AS ymdh
        FROM
            vd.supply_full_aggregations AS agg_table
        WHERE
            agg_table.account_id IN (1112)
            AND ymdh >= '2025-06-19 00:00:00'
            AND ymdh <= '2025-06-19 23:59:59'
            AND (agg_table.key_values ['channel_id'] IS NOT NULL)
            AND agg_table.supply_tag_id IN (
                select
                    object_id
                from
                    labels
                where
                    object_type = 'SupplyTag'
                    AND label_id IN (1698)
            )
        GROUP BY
            date_trunc('day', convert_timezone('UTC', 'UTC', ymdh)),
            agg_table.key_values ['channel_id']
    ) agg_table
GROUP BY
    date_trunc('day', ymdh),
    "key_channel_id"
ORDER BY
    ymdh ASC,
    total_requests DESC

-- QUERY ANALYSIS:
-- 
-- Purpose: This query analyzes advertising supply data with fraud detection metrics
-- 
-- Key Components:
-- 1. Revenue aggregation
-- 2. Total requests calculation (varies based on supply_router_id)
-- 3. WhiteOps fraud detection metrics with time-based delays
-- 4. Channel-based grouping
-- 
-- Time Logic:
-- - Main data range: 2025-06-19 (full day)
-- - Delayed metrics cutoff: 72 hours before 2025-06-20 10:00:00 (i.e., 2025-06-17 10:00:00)
-- 
-- Filters:
-- - Account ID: 1112
-- - Supply tags with label ID: 1698
-- - Non-null channel IDs
-- 
-- Output: Daily aggregated metrics by channel, ordered by date and request volume