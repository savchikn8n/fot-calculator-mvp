# Free Backup (GitHub Actions + Supabase)

This repository includes an automated workflow:

- File: `.github/workflows/supabase-backup.yml`
- Runs: every day (UTC) + manual run from GitHub Actions
- Output: `.dump` and `.sql.gz` backup artifacts in GitHub Actions

## One-time setup

1. Open GitHub repository -> `Settings` -> `Secrets and variables` -> `Actions`.
2. Click `New repository secret`.
3. Name: `SUPABASE_DB_URL`.
4. Value: your Supabase Postgres connection string from:
   - Supabase -> `Project Settings` -> `Database` -> `Connection string` (URI).
5. Save.

## Run backup manually

1. Open GitHub -> `Actions`.
2. Select workflow `Supabase DB Backup`.
3. Click `Run workflow`.

## Download backup

1. Open completed workflow run.
2. In `Artifacts`, download `supabase-backup-<run_id>`.
3. You will get:
   - `supabase-<timestamp>.dump`
   - `supabase-<timestamp>.sql.gz`

## Restore from backup

Use a local machine with PostgreSQL client installed.

Restore from dump:

```bash
pg_restore --clean --if-exists --no-owner --no-privileges -d "<TARGET_DB_URL>" supabase-YYYY-MM-DDTHH-MM-SSZ.dump
```

Restore from sql.gz:

```bash
gunzip -c supabase-YYYY-MM-DDTHH-MM-SSZ.sql.gz | psql "<TARGET_DB_URL>"
```

