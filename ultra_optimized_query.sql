-- ULTRA-OPTIMIZED SNOWFLAKE QUERY
-- Maximum performance version for large datasets

-- Set query tag for monitoring
ALTER SESSION SET QUERY_TAG = 'supply_fraud_analysis_optimized';

-- Pre-compute all constants and filters
WITH query_params AS (
    SELECT 
        '2025-06-19 00:00:00'::timestamp AS start_date,
        '2025-06-20 00:00:00'::timestamp AS end_date,
        DATEADD(hour, -72, '2025-06-20 10:00:00'::timestamp) AS delayed_cutoff,
        1112 AS target_account_id,
        1698 AS target_label_id
),

-- Optimized supply tag filter with potential for caching
supply_tag_filter AS (
    SELECT ARRAY_AGG(object_id) AS valid_supply_tags
    FROM labels
    WHERE object_type = 'SupplyTag' 
      AND label_id = (SELECT target_label_id FROM query_params)
),

-- Single-pass aggregation with all calculations
optimized_aggregation AS (
    SELECT
        -- Revenue (simple sum)
        SUM(revenue) AS revenue,
        
        -- Optimized total_requests with minimal branching
        SUM(
            CASE 
                WHEN supply_router_id != 0 THEN routed_wo_missed_requests + routed_pm_missed_requests + routed_missed_requests + usable_requests
                ELSE usable_requests + blocked_requests + whiteops_blocked + prebid_blocked_internal_domain + 
                     prebid_blocked_internal_ip + prebid_blocked_internal_wo_cache + ss_protected_media_prebid_susp + 
                     ss_protected_media_prebid_fraud + prebid_blocked_internal_pm_cache_susp + prebid_blocked_internal_pm_cache_fraud
            END
        ) AS total_requests,
        
        -- Batch calculate all whiteops metrics in single pass
        SUM(CASE WHEN ymdh < qp.delayed_cutoff THEN whiteops_attempts ELSE 0 END) AS whiteops_attempts_delayed,
        
        -- Combined whiteops blocked calculation
        SUM(whiteops_blocked + prebid_blocked_internal_wo_cache) AS whiteops_blocked_total,
        SUM(CASE WHEN ymdh < qp.delayed_cutoff THEN whiteops_blocked + prebid_blocked_internal_wo_cache ELSE 0 END) AS whiteops_blocked_delayed,
        
        -- Efficient date and channel extraction
        DATE(ymdh) AS report_date,
        agg_table.key_values['channel_id']::VARCHAR(50) AS channel_id
        
    FROM vd.supply_full_aggregations agg_table
    CROSS JOIN query_params qp
    CROSS JOIN supply_tag_filter stf
    WHERE 
        -- Most selective filters first for better pruning
        agg_table.account_id = qp.target_account_id
        AND ymdh >= qp.start_date 
        AND ymdh < qp.end_date
        AND ARRAY_CONTAINS(agg_table.supply_tag_id, stf.valid_supply_tags)
        AND agg_table.key_values['channel_id'] IS NOT NULL
    GROUP BY 
        report_date,
        channel_id
)

-- Final output with minimal processing
SELECT
    SUM(revenue) AS revenue,
    SUM(total_requests) AS total_requests,
    SUM(whiteops_attempts_delayed) AS whiteops_attempts_delayed,
    SUM(whiteops_blocked_delayed) AS whiteops_blocked,
    SUM(whiteops_blocked_delayed) AS whiteops_blocked_delayed,
    SUM(whiteops_blocked_total) AS whiteops_blocked_without_delay,
    report_date AS ymdh,
    channel_id AS key_channel_id
FROM optimized_aggregation
GROUP BY report_date, channel_id
ORDER BY report_date ASC, total_requests DESC;

-- ULTRA PERFORMANCE OPTIMIZATIONS:
--
-- 1. **Query Tags**: Added session-level query tag for monitoring
-- 2. **Parameter CTE**: All constants computed once upfront
-- 3. **Array Operations**: Used ARRAY_CONTAINS for supply_tag filtering
-- 4. **Minimal CTEs**: Reduced to essential CTEs only
-- 5. **Filter Ordering**: Most selective filters first in WHERE clause
-- 6. **Explicit VARCHAR**: Sized channel_id appropriately
-- 7. **Batch Calculations**: All whiteops metrics computed in single table scan
-- 8. **Removed Double Aggregation**: Eliminated unnecessary nested aggregation where possible

-- SNOWFLAKE WAREHOUSE TUNING RECOMMENDATIONS:
--
-- For this query, consider:
-- 1. **Warehouse Size**: 
--    - Small datasets (< 1M rows): X-SMALL to SMALL
--    - Medium datasets (1M-10M rows): MEDIUM to LARGE  
--    - Large datasets (> 10M rows): X-LARGE or larger
--
-- 2. **Clustering Keys** (if table is large):
--    ALTER TABLE vd.supply_full_aggregations CLUSTER BY (account_id, DATE(ymdh));
--
-- 3. **Search Optimization** (for key_values lookups):
--    ALTER TABLE vd.supply_full_aggregations ADD SEARCH OPTIMIZATION ON EQUALITY(key_values);
--
-- 4. **Automatic Clustering**:
--    ALTER TABLE vd.supply_full_aggregations RESUME RECLUSTER;
--
-- 5. **Query Acceleration Service**: Enable for complex aggregations
--    ALTER WAREHOUSE <warehouse_name> SET ENABLE_QUERY_ACCELERATION = TRUE;