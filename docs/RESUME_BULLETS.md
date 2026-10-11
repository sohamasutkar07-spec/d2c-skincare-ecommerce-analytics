# Resume Bullets and Interview Talking Points

This file contains concise resume wording for the analyses completed in this repository. Use claims only after rerunning and checking the corresponding query output.

## Project entry

**D2C E-Commerce Sales & Customer Experience Analytics**  
*Tools: MySQL 8.0, SQL, Generative AI (GenAI)*

- Validated data across six related synthetic e-commerce tables containing 1,250 orders, 2,042 order items, 28 products, 79 return records, and 494 reviews; reconciled delivered-order item totals, merchandise amounts, and shipping charges, finding zero discrepancies in the checks performed.
- Analyzed order status and monthly sales using SQL aggregation, date functions, conditional logic, and window functions; identified a 12.89% year-over-year decline in delivered order value from October 2024 to October 2025.
- Evaluated product revenue and estimated gross profitability using multi-table JOINs and aggregate functions; identified Alpha Arbutin 2% Serum as the leading product by delivered merchandise revenue at 76,549.55, with estimated gross profit of 38,589.55.
- Investigated return reasons, resolution statuses, and product ratings; found skin irritation accounted for 35.44% of recorded returns and identified products with lower average ratings for follow-up investigation.
- Used GenAI as a learning and productivity aid to clarify SQL concepts, troubleshoot syntax, review query logic, and organize documentation; ran the queries and checked the resulting outputs in MySQL Workbench.

**Metric caveats:** The dataset is synthetic and its currency is unspecified. Gross profit is an estimate based on product cost per unit and excludes operating expenses. Return reason percentages are shares of return records, not product return rates.

## Separate credential

**GenAI Powered Data Analytics Job Simulation — Forage**  
*Completed October 2026*

- Completed practical tasks covering exploratory data analysis and risk profiling, AI-assisted delinquency prediction, business reporting and data storytelling for collections strategy, and implementation of an AI-driven collections strategy.

Keep this credential separate from the skincare project. The simulation covers a different business scenario.

## Interview talking points

**How did you use GenAI?**  
“I used GenAI to break down SQL concepts, debug syntax errors, review query structure, and improve documentation. I executed the queries in MySQL Workbench and checked the results rather than assuming an AI-generated query was correct.”

**What business problem did the project explore?**  
“It examined order performance, the October year-over-year decline in delivered order value, product revenue and estimated gross profit, common return reasons, and product ratings.”

**What was the biggest data-quality check?**  
“I reconciled delivered order items to the order-level merchandise amount and confirmed that the final order amount matched merchandise plus shipping fees for the delivered orders in the dataset.”

**What are the limitations?**  
“The dataset is synthetic, the currency is unspecified, estimated gross profit excludes operating expenses, and the return reason share is not the same as a product return rate.”
