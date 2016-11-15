WITH tables AS (
  SELECT
    relname,
    pg_stat_get_last_vacuum_time(c.oid) AS last_vacuum_time,
    pg_stat_get_last_autovacuum_time(c.oid) AS last_autovacuum_time
  FROM pg_class AS c
  WHERE c.relkind IN ('r', 'm')
)
SELECT *
FROM tables
ORDER BY GREATEST(last_vacuum_time, last_autovacuum_time)
