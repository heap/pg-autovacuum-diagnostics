SELECT
  nspname,
  relname,
  dead_tuples,
  autovacuum_threshold,
  (dead_tuples * 1.0 / autovacuum_threshold) AS pct_dead
FROM (
  SELECT
    nspname,
    relname,
    pg_stat_get_dead_tuples(c.oid) AS dead_tuples,
    round(
      current_setting('autovacuum_vacuum_threshold')::INTEGER +
        current_setting('autovacuum_vacuum_scale_factor')::NUMERIC * reltuples
    ) AS autovacuum_threshold
  FROM pg_class AS c, pg_namespace AS n
  WHERE
    c.relnamespace = n.oid AND
    c.relkind IN ('r', 't', 'm')
) t
WHERE dead_tuples > autovacuum_threshold
ORDER BY pct_dead DESC
