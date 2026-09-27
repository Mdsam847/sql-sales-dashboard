-- schema.sql
-- Run this after importing data/sales_data.csv into a SQLite database.
--
-- Quick start (from the project root):
--   sqlite3 sales.db
--   sqlite> .mode csv
--   sqlite> .import data/sales_data.csv orders_raw
--   sqlite> .read sql/schema.sql
--   sqlite> .read sql/analysis_queries.sql

CREATE TABLE IF NOT EXISTS orders (
    order_id          INTEGER PRIMARY KEY,
    order_date        TEXT NOT NULL,     -- ISO 8601, e.g. 2026-03-14
    region            TEXT NOT NULL,     -- North / South / East / West
    category          TEXT NOT NULL,     -- Electronics / Furniture / Office Supplies / Clothing
    product           TEXT NOT NULL,
    customer_segment  TEXT NOT NULL,     -- Consumer / Corporate / Home Office
    quantity          INTEGER NOT NULL,
    unit_price        REAL NOT NULL,
    sales             REAL NOT NULL,     -- quantity * unit_price
    profit            REAL NOT NULL
);

-- If you imported the CSV straight into `orders_raw`, promote it into the
-- typed table above (SQLite's .import creates every column as TEXT):
INSERT INTO orders
SELECT
    CAST(order_id AS INTEGER),
    order_date,
    region,
    category,
    product,
    customer_segment,
    CAST(quantity AS INTEGER),
    CAST(unit_price AS REAL),
    CAST(sales AS REAL),
    CAST(profit AS REAL)
FROM orders_raw
WHERE order_id != 'order_id';  -- skip header row if it was imported as data

CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_region ON orders(region);
