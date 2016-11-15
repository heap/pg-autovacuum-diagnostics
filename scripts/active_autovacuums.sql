SELECT
  pid,
  state,
  NOW() - query_start AS running_time,
  query
FROM pg_stat_activity
WHERE
  query LIKE 'autovacuum:%' AND
  state = 'active'
