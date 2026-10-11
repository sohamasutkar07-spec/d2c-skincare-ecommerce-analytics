# D2C Skincare E-Commerce Sales & Customer Experience Analytics

**Portfolio project | MySQL 8.0 | Entry-level Data Analyst**

## Project overview

This project analyzes a synthetic direct-to-consumer skincare e-commerce dataset to understand sales performance, product economics, order outcomes, returns, and customer reviews. The SQL files are limited to the analyses covered in the guided project; no extra advanced analysis has been added.

The analysis is designed to answer practical business questions:
- How are orders distributed by status?
- What are delivered order value and average delivered order value?
- How did monthly sales change year over year?
- Which products drive the most delivered merchandise revenue and estimated gross profit?
- What are the leading return reasons and product-rating patterns?

> **Data disclaimer:** The dataset is synthetic and intended for learning and portfolio use. Results do not represent a real business. The currency is not explicitly specified in the source, so values are presented without a currency symbol.

## Dataset

The project uses six related CSV tables:

| Table | Analytical role |
|---|---|
| Customers | Customer profile and acquisition channel |
| Orders | Order date, status, payment, sales channel, order-level amounts |
| Order_Items | Product, quantity, discount percentage, discounted item total |
| Products | Product category, price, unit cost and stock |
| Returns | Return reasons and recorded resolution status |
| Reviews | Product ratings and review dates |

Main relationships:
- `Customers.customer_id` → `Orders.customer_id`
- `Orders.order_id` → `Order_Items.order_id`
- `Products.product_id` → `Order_Items.product_id`
- `Orders.order_id` → `Returns.order_id`
- `Products.product_id` → `Returns.product_id`
- `Customers.customer_id` → `Reviews.customer_id`
- `Products.product_id` → `Reviews.product_id`
- `Orders.order_id` → `Reviews.order_id`

## Tools and SQL skills

- MySQL 8.0
- Data profiling and quality checks
- Date parsing and cleaning
- Aggregations, filtering, grouping and sorting
- Multi-table `JOIN`s
- Conditional aggregation with `CASE`
- Common table expressions (CTEs) for the order-total reconciliation already covered in the project
- Window functions for percentage calculations
- KPI definition and business interpretation

## GenAI-assisted workflow

Generative AI was used as a learning and productivity aid during this project to:
- break business questions into manageable SQL steps;
- explain SQL concepts and troubleshoot syntax errors;
- review query structure and clarify metric definitions; and
- organize project documentation and findings.

The project owner imported the CSV files, ran the queries in MySQL Workbench, checked outputs, and reviewed the business interpretation. AI suggestions were treated as drafts to verify, not as proof that a query or result was correct.

## Additional GenAI learning

**GenAI Powered Data Analytics Job Simulation — Forage (October 2026)**

The separately completed simulation covered exploratory data analysis and risk profiling, AI-assisted delinquency prediction, business reporting and data storytelling for collections strategy, and implementation of an AI-driven collections strategy. This simulation is a separate learning credential, not part of the skincare dataset analysis.

## Metric definitions

- **Delivered orders:** Orders where `order_status = 'Delivered'`.
- **Delivered order amount:** Sum of `final_amount` for delivered orders. In this dataset, reconciliation found that `final_amount = gross_amount + shipping_fee`.
- **Delivered merchandise revenue:** Sum of discounted `Order_Items.item_total` for line items belonging to delivered orders; shipping is excluded.
- **Average delivered order value:** Average `final_amount` across delivered orders.
- **Estimated COGS:** Sum of item quantity multiplied by product `cost_price`, assuming that field represents cost per unit.
- **Estimated gross profit:** Delivered merchandise revenue less estimated COGS. This is not net profit and excludes marketing, fulfilment, overheads and other operating costs.
- **Return reason share:** Number of return records for a reason divided by all return records. This is not a product return rate.

## Verified findings

These values were observed in the supplied synthetic data and should be rechecked by running the SQL in MySQL Workbench.

- 1,250 orders in the order table, including 1,020 delivered orders.
- Delivered orders represented 81.60% of all orders.
- Total delivered order amount was 981,950.65; average delivered order value was 962.70.
- October delivered order amount decreased from 75,502.25 in October 2024 to 65,772.75 in October 2025, a 12.89% year-over-year decline.
- Alpha Arbutin 2% Serum was the leading product by delivered merchandise revenue in the query results, at 76,549.55.
- Skin irritation was the most common recorded return reason: 28 of 79 return records (35.44%).
- Body Wash with Salicylic Acid had the lowest average rating in the queried products with at least five reviews (3.25 across 12 reviews); Vitamin B5 Moisturizer had the highest (4.50 across 26 reviews).
- Reconciliation for delivered orders found no orders without order items and no mismatches between item totals and order-level merchandise amount, or between final amount and merchandise plus shipping.

## Setup and execution

1. Install MySQL 8.0 or later and open MySQL Workbench.
2. Create the `skincare_analytics` database.
3. Import the six source CSV files into staging tables using the Table Data Import Wizard, checking each CSV column mapping.
4. Run the SQL scripts in sequence after verifying the schema and table names.
5. Run the validation queries before interpreting analytical outputs.
6. Save selected query outputs or screenshots as evidence in the repository.
7. Optionally connect the validated tables or reporting views to Power BI to create a dashboard.

## Repository structure

```text
.
├── README.md
├── sql/
│   ├── 01_create_staging_tables.sql
│   ├── 02_clean_tables_and_quality_checks.sql
│   ├── 03_sales_and_orders.sql
│   ├── 04_product_performance.sql
│   └── 05_returns_and_reviews.sql
├── data/
│   ├── Customers.csv
│   ├── Orders.csv
│   ├── Order_Items.csv
│   ├── Products.csv
│   ├── Returns.csv
│   └── Reviews.csv
└── docs/
    ├── SQL_REVIEW_NOTES.md
    ├── PROJECT_FINDINGS.md
    └── RESUME_BULLETS.md
```

## Limitations

- Dataset is synthetic; findings should not be presented as outcomes for a real company.
- Currency is unspecified in the supplied data.
- Gross profit is an estimate based on `cost_price` as unit cost and does not include operating expenses.
- Return counts do not equal return rates; proper rates need an appropriate sales or units denominator.
- Correlation and frequency patterns do not establish causation.
- Confirm the scripts execute end-to-end in your local MySQL instance before describing them as fully tested.

## Author

Portfolio project by Soham Asutkar.
