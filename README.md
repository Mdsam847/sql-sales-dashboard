# SQL Sales Performance Dashboard

A small end-to-end reporting project: raw order data → SQL aggregation (including window functions) → a static HTML dashboard, built to practice the SQL-for-reporting workflow.

**[View the live dashboard →](dashboard.html)** *(once pushed, enable GitHub Pages on this repo and link the live URL here instead)*

## What this shows

- Writing a normalized schema and loading CSV data into SQLite
- `GROUP BY` aggregation across multiple dimensions (region, category, segment, month)
- Window functions: `LAG()` for month-over-month growth, `SUM() OVER` for a running total
- Turning query output into a report a non-technical stakeholder can read

## Project structure

```
sql-sales-dashboard/
├── data/
│   ├── sales_data.csv        # 210 synthetic orders, Jan–Jun 2026
│   └── dashboard_data.json   # pre-computed query results (feeds the dashboard)
├── sql/
│   ├── schema.sql             # table definition + CSV import
│   └── analysis_queries.sql   # the 8 queries behind every chart/table
├── dashboard.html              # self-contained report (no server needed)
└── README.md
```

## Run it yourself

```bash
sqlite3 sales.db
sqlite> .mode csv
sqlite> .import data/sales_data.csv orders_raw
sqlite> .read sql/schema.sql
sqlite> .read sql/analysis_queries.sql
```

Then open `dashboard.html` directly in a browser — it has no build step and no backend, so it also works straight from GitHub Pages.

## Sample insight

Querying the dataset surfaces things like: Furniture drives 67% of revenue despite being one of four categories, and April–May saw +80% and +83% month-over-month growth off a slow Q1 — the kind of finding a `LAG()` window function makes a one-line query instead of a spreadsheet exercise.

## Data note

The dataset in `data/sales_data.csv` is synthetically generated (see the pattern is intentionally realistic but not real transactions) so the project can be shared publicly without any privacy concerns. Swap in a real CSV with the same columns and everything else — schema, queries, dashboard — works unchanged.

## Tools

SQLite · Chart.js · vanilla HTML/CSS/JS
