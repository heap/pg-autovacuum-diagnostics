# pg-autovacuum-diagnostics
Queries to diagnose vacuum and autovacuum problems in PostgreSQL.

These can be used to understand why autovacuums aren't running, when they were
last run, which particular tables are overdue.


## Autovacuum Backlog

**Which tables are overdue for a vacuum on account of having dead rows?** See:
``overdue_for_autovacuum.sql``

**Which tables are overdue for an aggressive vacuum to prevent xid wraparound?**
See: ``overdue_for_aggressive_autovacuum.sql``

You can replace the ``current_setting`` invocations in these queries with
different values to see how this backlog would change under different
configurations.

If you see a lot of tables in this backlog and you would like more vacuuming to
be happening, a more aggressive configuration might help. If you do not see a
lot of tables in this backlog, but you suspect that there are tables with lots
of bloat, you might have table statistics that are out of date. Consider
running ``ANALYZE`` on a few tables and seeing if they start showing up in the
result set for this query.

If a lot of tables are overdue for an aggressive vacuum in particular, you
might want to decrease ``vacuum_freeze_min_age``, though this might incur an
additional I/O cost if you are frequently updating rows after freezing them.


## Active And Recent Autovacuums

**Are autovacuum tasks currently running?** See: ``active_autovacuums.sql``

**When was each table most recently vacuumed?** See: ``last_vacuum_times.sql``

If you are running fewer than ``autovacuum_max_workers`` tasks, but you have a
backlog of tables needing autovacuums, the issue might be
``autovacuum_naptime``.

On the other hand, if you are running as many autovacuum tasks as allowed by
your configuration, the issue might be that they aren't making enough progress.
In that case, consider increasing ``vacuum_cost_limit`` or decreasing
``vacuum_cost_delay``, or the autovacuum-specific analogues.
