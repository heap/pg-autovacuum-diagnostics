WITH tables AS (
  SELECT
    c.relname,
    GREATEST(age(c.relfrozenxid), age(t.relfrozenxid)) AS age
  FROM pg_class AS c
    LEFT JOIN pg_class AS t ON c.reltoastrelid = t.oid
  WHERE c.relkind IN ('r', 'm')
)
SELECT *
FROM tables
WHERE age >= current_setting('autovacuum_freeze_max_age')::INTEGER
ORDER BY age DESC
