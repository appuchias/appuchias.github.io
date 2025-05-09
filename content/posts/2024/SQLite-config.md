---
title: 'SQLite configuration tips'
desciption: 'Some tips for SQLite in prod'
author: Appuchia
date: 2024-01-20
lastmod: 2025-01-17
categories:
    - EN
    - Development
tags:
    - DB
#cover:
#    image: '/images/2024 01 20_SQLite Config'
---

This post covers some settings I have discovered about SQLite these days that
help it perform better without losing consistency.

The official reference and the sources of my discoveries will be listed in the
[References]({{< ref "#references" >}}) section below.

This will be a short one, mainly to help future me, but also for anyone planning
to use SQLite in production (including me).

# Configuring SQLite

A few days ago I thought SQLite didn't need any configuration but oh boy was I 
wrong.

To configure SQLite you use the `PRAGMA` command in the DB:

- You can query the current `value` of a `setting`, with `PRAGMA setting;`
- Or set a new `value`, using `PRAGMA setting=value;`

# The tips

A one-liner with all settings will be [at the end]({{< ref "#one-liner" >}}).
> ## Journal mode
>
> `PRAGMA journal_mode=WAL;`
>
> This changes the default journaling mode fron DELETE to WAL (Write-Ahead Log)
> which allows reading from the DB while also writing to it as one of its
> features.
>
> This feature can be used with SQLite 3.7.0 (2010-07-21) or later.
>
> [Documentation](https://www.sqlite.org/pragma.html#pragma_journal_mode)

> ## Synchronous
>
> `PRAGMA synchronous=normal;`
>
> The default value of 2 (FULL) is not needed if WAL is enabled, and changing it
> to 1 (NORMAL) improves speed while not losing safety.
>
> [Documentation](https://www.sqlite.org/pragma.html#pragma_synchronous)

> ## Busy timeout
>
> `PRAGMA busy_timeout=5000;`
>
> This sets the time write transactions will wait to start at maximum (in ms).
> If unset, they would fail immediately if the database is locked.
>
> [Documentation](https://www.sqlite.org/pragma.html#pragma_busy_timeout)

> ## Foreign keys
>
> `PRAGMA foreign_keys=ON;`
>
> SQLite does not enforce FKs by default, so this enables its enforcement as
> it's highly recommended.
> It will slightly reduce performance.
>
> Please use foreign keys.
> 
> [Documentation](https://www.sqlite.org/pragma.html#pragma_foreign_keys)

## One-liner

For a database stored in `db.sqlite3`:

```shell
sqlite3 db.sqlite3 "PRAGMA journal_mode=WAL; PRAGMA synchronous=normal; PRAGMA busy_timeout=5000; PRAGMA foreign_keys=ON;"
```

# Other important commands

Some other useful commands that can be used in the SQLite shell:

- `VACUUM;` - Rebuilds the DB file, useful to shrink it after deletions (reclaims disk space).
- `PRAGMA optimize;` - Updates the query planner's statistics if needed ([PRAGMA docs](https://www.sqlite.org/pragma.html#pragma_optimize), [ANALYZE docs](https://sqlite.org/lang_analyze.html)).
- `PRAGMA integrity_check;` - Checks the integrity of the DB.
- `PRAGMA foreign_key_check;` - Checks the FK constraints.

# References

- [The official SQLite documentation](https://www.sqlite.org/docs.html)
- [Tom Dyson's talk on DjangoCon Europe 2023](https://www.youtube.com/watch?v=yTicYJDT1zE)
- [Ben Johnson's talk on GopherCon 2021](https://www.youtube.com/watch?v=XcAYkriuQ1o)

And [another nice post](https://cj.rs/blog/sqlite-pragma-cheatsheet-for-performance-and-consistency/)
covering similar configurations that I found after writing mine.

---

Thanks for reading!

Done with 🖤 by Appu.
