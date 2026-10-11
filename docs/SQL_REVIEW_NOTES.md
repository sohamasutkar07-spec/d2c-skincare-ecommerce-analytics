# SQL Review Notes

## Scope

This repository keeps the SQL analyses to the set worked through in the guided project. No additional customer segmentation, category-analysis, or other advanced business queries have been added beyond that scope. The goal is for the portfolio owner to be able to explain each query and result in an interview.

## Corrections made to the submitted SQL

1. Corrected the malformed product-detail query that had an extra comma and misplaced revenue-contribution expression.
2. Matched the order-item staging columns to the supplied CSV headers: `discount_pct` and `item_total`.
3. Used `%Y-%m` for the month label to preserve the four-digit year and chronological month sorting.
4. Kept the project scripts organized by staging, the cleaning and validation queries already covered, order/revenue analysis, product revenue/profit estimates, and returns/reviews.
5. Documented the metric definitions used in the existing analyses: `gross_amount` matches discounted merchandise totals, while `final_amount` matches merchandise amount plus shipping.
6. Kept product revenue contribution calculated using the total for all products in the delivered-order population, before displaying the top 10.
7. Marked estimated gross profit as an estimate based on `quantity * cost_price`; it is not net profit. Return-reason percentages are shares of return records, not product return rates.

## Running instructions

- CSV imports are manual in MySQL Workbench. The scripts do not use `LOAD DATA` because local file paths, `LOCAL INFILE` settings, and server permissions differ by machine.
- Run `sql/01_create_staging_tables.sql`, import all six CSVs into their matching raw tables, then run `sql/02_clean_tables_and_quality_checks.sql`.
- Run the remaining analysis files only after those tables and imports exist.
- The queries have been reviewed for consistency, but the full package has not been executed end-to-end against a live MySQL server. Run them in MySQL Workbench and inspect the outputs before describing the project as fully tested.
- The source dataset is synthetic and for educational/portfolio purposes. Do not represent findings as real-company results.
