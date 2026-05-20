# Amazon Sales Analysis — SQL Project

**By Twinkle**

---

## Why This Project?

I wanted to work on something that actually feels real .
Amazon's e-commerce structure has customers, products, orders, discounts, taxes, shipping — everything a real business deals with.

So I picked this Kaggle dataset, wrote every query from scratch, and tried to answer questions a business analyst would actually be asked:
*Who are our best customers? Which products are dragging? Where is the money coming from?*

This project is my attempt at thinking like an analyst — not just writing SQL.

---

## Dataset

- **Source** : Kaggle
- **Table** : `amazon__sales` (flat raw table)
- **Size** : 1,00,000 rows | 99,984 unique orders
- **Scope** : Orders across multiple countries, categories, payment methods

---

## What I Built

Started with one messy flat table. Cleaned it. Normalized it into 4 tables. Then ran analysis on top of it.

```
amazon__sales (raw)
        │
        ├── customers       → who bought
        ├── products        → what was sold
        ├── orders          → when and how
        └── order_detail    → quantities, discounts, tax, shipping
```

Normalization wasn't just "good practice" — it made every JOIN cleaner and every query faster to write and debug.

---

## SQL Concepts Used

| Concept | Where I Used It |
|---|---|
| `JOIN` | Connecting customers → orders → products across all analysis |
| `GROUP BY` + Aggregates | Revenue, quantity, order counts by category/brand/country |
| `HAVING` | Filtering repeat customers, above-average spenders |
| Window Functions | Cumulative revenue growth, product revenue ranking |
| Subqueries | Products above category average price, never-sold products |
| CTEs | Category revenue breakdown — cleaner than nesting |
| `CASE` | Profit vs Loss check after discounts |
| `EXTRACT()` | Monthly sales trend from order dates |
| `FILTER (WHERE ...)` | Null checks column by column during data cleaning |

---

## Numbers That Actually Came Out

These are real query results — not made up.

### Scale
| Metric | Value |
|---|---|
| Total Revenue | ₹ 9,18,25,647.92 |
| Total Orders | 1,00,000 |
| Unique Products | 99,984 |

---

### Top 5 Products by Revenue

| Product | Revenue |
|---|---|
| LED Desk Lamp | ₹ 4,03,22,47,764 |
| Water Bottle | ₹ 3,95,77,37,079 |
| Memory Card 128GB | ₹ 3,94,18,76,920 |
| Electric Kettle | ₹ 3,91,25,08,424 |
| Mechanical Keyboard | ₹ 3,87,87,63,840 |

---

### Top Products by Quantity Sold

| Product | Units Sold |
|---|---|
| LED Desk Lamp | 1,33,09,712 |
| Water Bottle | 1,31,02,200 |
| Router | 1,27,38,908 |
| Memory Card 128GB | 1,27,10,880 |
| Electric Kettle | 1,26,56,745 |

---

### Revenue by Category

| Category | Revenue |
|---|---|
| Electronics | ₹ 30,95,71,79,233 |
| Sports & Outdoors | ₹ 30,86,33,63,074 |
| Books | ₹ 30,76,42,54,939 |
| Home & Kitchen | ₹ 30,51,02,09,132 |
| Toys & Games | ₹ 30,39,55,97,096 |
| Clothing | ₹ 30,20,19,81,437 |

---

### Payment Method Breakdown

| Method | Orders |
|---|---|
| Credit Card | 35,038 |
| Debit Card | 20,024 |
| UPI | 15,066 |
| Amazon Pay | 15,017 |
| Net Banking | 9,927 |
| Cash on Delivery | 4,928 |

---

### Order Status

| Status | Count |
|---|---|
| Delivered | 74,628 |
| Shipped | 15,192 |
| Pending | 4,103 |
| Returned | 3,049 |
| Cancelled | 3,028 |

---

### Revenue by Country

| Country | Revenue |
|---|---|
| United States | ₹ 1,92,37,64,70 |
| India | ₹ 4,15,40,355 |
| Canada | ₹ 1,60,19,953 |
| United Kingdom | ₹ 1,35,80,379 |
| Australia | ₹ 1,14,64,351 |

---

### Revenue After Discount

| Gross Revenue | Net Revenue | Status |
|---|---|---|
| ₹ 9,18,25,647.92 | ₹ 9,18,18,225.32 | ✅ Profit |

---

## Insights That Actually Surprised Me

**1. Electronics leads — but barely.**
Electronics generated ₹30.95Cr. But Sports & Outdoors was just ₹91Cr behind.
Every category is within 3% of each other. This platform isn't dependent on one category — revenue is genuinely diversified.

**2. Cash on Delivery is almost dead.**
Only 4,928 orders out of 1,00,000 used COD — that's under 5%.
Credit Card dominates at 35%. Customers have clearly shifted to digital payments.
For a business, this means lower return rates and faster settlements.

**3. LED Desk Lamp is the undisputed #1.**
Top in quantity sold AND top in revenue.
It's not just popular — it's also priced well enough to generate maximum value.
A product that wins on both metrics is rare.

**4. 74% orders delivered successfully.**
74,628 out of 1,00,000 orders delivered. Only 3% returned and 3% cancelled.
That's a healthy fulfillment rate — returns and cancellations are well under control.

**5. USA drives almost everything.**
US revenue vs India's revenue — the gap is massive.
International expansion beyond US has significant room to grow.

**6. Discounts barely dented profit.**
Gross: ₹9,18,25,647 → Net after discount: ₹9,18,18,225.
The difference is negligible. Discounts are being used smartly — not eating into margins.

---

## Conclusion

This project taught me that SQL is not just about writing queries — it's about asking the right questions first.

Before I wrote a single line, I had to think:
*What does this business care about? Revenue? Customers? Products? All three.*

The normalization step was the most valuable part — once the 4 tables were clean, every query became logical and easy to debug.

The insight I'll carry forward: **numbers alone don't tell the story.**
The fact that all 6 categories are within 3% revenue of each other — a simple `SUM` query shows the number, but the interpretation is what matters.

That's what I want to keep building — not just query-writing, but business thinking through data.

---

## Tools

- **Database** : PostgreSQL
- **Dataset** : [Amazon Sales Dataset — Kaggle](https://www.kaggle.com)
- **Language** : SQL only

---

*Made by Twinkle — open to feedback, suggestions, and SQL discussions!* 🙂
