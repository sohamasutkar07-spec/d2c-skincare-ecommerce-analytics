# Review notes on the submitted SQL

## Corrections made in the portfolio version

1. **Removed an invalid query fragment.** The submitted script had a dangling comma and misplaced revenue-contribution expression in a product-detail query, which would cause a syntax error.
2. **Corrected the order-item staging schema.** Order_Items.csv contains discount_pct and item_total; the setup script now creates those columns directly instead of requiring an ALTER TABLE rename after import.
3. **Standardized date formatting.** Monthly labels use %Y-%m (four-digit year and numeric month) so sorting is chronological. Earlier %y-%m labels displayed a two-digit year.
4. **Separated staging, cleaning, and analysis.** The submitted file interleaved table creation, manual CSV import steps, and queries. The portfolio files document a safer run order.
5. **Clarified metric definitions.** In this dataset, gross_amount reconciles to the sum of item_total and represents discounted merchandise value; final_amount reconciles to gross_amount + shipping_fee. KPI labels distinguish merchandise revenue from order value including shipping.
6. **Scoped the product-contribution denominator correctly.** Revenue contribution is calculated against all products in the delivered-order population before the top-10 display limit.
7. **Added data-quality checks.** The cleaning file checks missing dates and IDs, duplicates, orphan relationships, invalid ratings, and order-total reconciliation.
8. **Clarified estimates and caveats.** Gross profit is estimated from quantity * cost_price and item revenue. It is not net profit and excludes operating expenses. Return counts are not return rates.

## Running instructions

- CSV imports are manual in MySQL Workbench. The scripts do not use LOAD DATA because local file paths, LOCAL INFILE settings, and server permissions differ by machine.
- Run 01_create_staging_tables.sql, import all six CSVs into their matching tables, then run 02_clean_tables_and_quality_checks.sql.
- Run the analysis files only after clean tables exist.
- The queries have been reviewed for consistency, but the full package has not been executed end-to-end against a live MySQL server. Run them in MySQL Workbench and inspect outputs before describing them as fully tested.
- The source dataset is synthetic and for educational / portfolio purposes. Do not represent findings as real-company results.
