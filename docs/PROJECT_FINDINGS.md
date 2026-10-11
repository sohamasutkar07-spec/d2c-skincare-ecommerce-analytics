# Project Findings

These findings were calculated from the supplied **synthetic** skincare e-commerce dataset using MySQL. They are portfolio case-study results, not results from a real company. Currency is unspecified in the source, so values are shown without a currency symbol.

## 1. Order status

| Status | Orders | Share |
|---|---:|---:|
| Delivered | 1,020 | 81.60% |
| Cancelled | 86 | 6.88% |
| Returned | 79 | 6.32% |
| In Transit | 65 | 5.20% |
| **Total** | **1,250** | **100.00%** |

The majority of recorded orders are delivered. Cancelled, returned, and in-transit orders should be analyzed separately because their operational meanings differ.

## 2. Delivered-order KPIs

- Delivered orders: **1,020**
- Total delivered order value including shipping: **981,950.65**
- Average delivered order value including shipping: **962.70**

Reconciliation on delivered orders found zero orders without order items, zero differences between item totals and order-level merchandise amounts, and zero differences between final order amount and merchandise amount plus shipping fee.

## 3. October year-over-year comparison

| Metric | October 2024 | October 2025 |
|---|---:|---:|
| Delivered orders | 69 | 67 |
| Delivered order value including shipping | 75,502.25 | 65,772.75 |

Delivered order value including shipping declined by **12.89%** year over year. Delivered order count declined by **2.90%**. Since order value declined faster than order count, average order value also decreased. This describes what changed; further product-mix, discount, and basket analysis would be needed to explain why.

## 4. Product performance

- **Alpha Arbutin 2% Serum** led the submitted product revenue ranking, with delivered merchandise revenue of **76,549.55**.
- Its estimated gross profit was **38,589.55**, with an estimated gross margin of **50.41%**, assuming product cost is per unit.
- In the reported top-10 product results, **SPF 60 PA++++ Sunscreen** had the highest estimated gross margin at **53.15%**.
- The revenue-leading product and margin-leading product are not the same, illustrating why sales and product economics should be reviewed together.

Estimated gross profit is not net profit. It excludes marketing, fulfilment overhead, operating expenses, and other costs not represented in this dataset.

## 5. Return reasons and recorded resolution status

| Return reason | Records | Share of returns |
|---|---:|---:|
| Skin irritation | 28 | 35.44% |
| Late delivery | 16 | 20.25% |
| Damaged packaging | 13 | 16.46% |
| Wrong item received | 12 | 15.19% |
| Changed mind | 10 | 12.66% |

Skin irritation is the most frequently recorded return reason. The business could investigate product-level patterns and review feedback. This is not evidence that any specific product caused an irritation event.

Recorded resolution status:

| Status | Records | Share of returns |
|---|---:|---:|
| Replacement Sent | 28 | 35.44% |
| Refunded | 26 | 32.91% |
| Under Review | 25 | 31.65% |

About one-third of return records were marked Under Review. A follow-up could examine case age and resolution timelines. The source field includes replacement and review states, so it is described as a recorded return-resolution status rather than solely a refund status.

## 6. Product ratings

Among products with at least five reviews:
- Lowest average rating: **Body Wash with Salicylic Acid**, **3.25** from 12 reviews.
- Highest average rating: **Vitamin B5 Moisturizer**, **4.50** from 26 reviews.

Review averages indicate where further investigation may be useful; they do not establish the reasons behind customer sentiment. Review volume should be considered alongside the average rating.

## 7. Recommended business follow-ups

1. Compare product-level return counts with units sold to calculate properly denominated return rates.
2. Investigate return reasons and review sentiment for lower-rated products.
3. Decompose the October order-value decline by product/category, discount, channel, and average basket.
4. Build a Power BI dashboard with consistent definitions for merchandise revenue and order value including shipping.

## Definitions and limitations

- **Merchandise revenue:** Discounted item totals from order items belonging to delivered orders; shipping excluded.
- **Delivered order value:** Sum of final amount for delivered orders; in this dataset, final amount reconciles to merchandise amount plus shipping.
- **Estimated COGS:** Quantity multiplied by product cost price, assuming cost price is per unit.
- **Return reason share:** Return records for a reason divided by all return records. It is not a product return rate.
- Dataset is synthetic; currency is unspecified; results must not be represented as real-company performance.
