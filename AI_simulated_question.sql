WITH base AS (
  SELECT
    DATE_TRUNC('week', created_at) AS week_start,
    channel,
    EXTRACT(EPOCH FROM (resolved_at - created_at)) / 60.0 AS resolution_minutes
  FROM support_tickets
  WHERE
    created_at >= CURRENT_DATE - INTERVAL '30 days'
    AND resolved_at IS NOT NULL
    AND EXTRACT(EPOCH FROM (resolved_at - created_at)) / 60.0 <= 1440
),

ranked AS (
  SELECT
    week_start,
    channel,
    resolution_minutes,
    ROW_NUMBER() OVER (
      PARTITION BY week_start, channel
      ORDER BY resolution_minutes
    ) AS rn,
    COUNT(*) OVER (
      PARTITION BY week_start, channel
    ) AS cnt
  FROM base
)

SELECT
  week_start,
  channel,
  AVG(resolution_minutes) AS median_resolution_minutes
FROM ranked
WHERE rn IN (
  (cnt + 1) / 2,
  (cnt + 2) / 2
)
GROUP BY week_start, channel
ORDER BY week_start, channel;
