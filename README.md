# P1 - Jaffle Shop Customer Analytics

Analytics Engineering project developed with **dbt Cloud** and **BigQuery** using the Jaffle Shop and Stripe datasets.

The objective of this project is to transform raw transactional data into analytics-ready models that support customer behavior analysis, payment performance monitoring, and sales reporting.

---

## Project Goals

This project aims to answer business questions such as:

* Who are the most valuable customers?
* Which payment methods are most frequently used?
* What is the distribution of successful and failed payments?
* How are customers distributed based on purchase frequency and monetary value?
* What is the impact of payment failures on customer value?

Although the source data is intentionally simple, the project was designed following Analytics Engineering best practices and can be easily extended with additional customer, product, and geographic dimensions.

---

## Tech Stack

| Tool                | Purpose                               |
| ------------------- | ------------------------------------- |
| dbt Cloud           | Data transformation and orchestration |
| BigQuery            | Cloud Data Warehouse                  |
| GitHub              | Version control                       |
| dbt Docs            | Documentation and lineage             |
| Jaffle Shop Dataset | Customers and Orders source           |
| Stripe Dataset      | Payments source                       |

---

## Project Structure

```text
models/
└── p1_jaffle_shop
    ├── _p1_docs
    │   ├── jaffle_shop_customers_docs.md
    │   ├── jaffle_shop_orders_docs.md
    │   └── stripe_payments_docs.md
    │
    ├── 0_sources
    │   ├── _src_jaffle_shop.yml
    │   └── _src_stripe.yml
    │
    ├── 1_staging
    │   ├── _stg_p1.yml
    │   ├── stg_jaffle_shop__customers.sql
    │   ├── stg_jaffle_shop__orders.sql
    │   └── stg_stripe__payments.sql
    │
    ├── 2_intermediate
    │   ├── _int_customers.yml
    │   ├── _int_orders.yml
    │   ├── _int_payments.yml
    │   ├── int_customers_metrics.sql
    │   ├── int_order_status_metrics.sql
    │   ├── int_orders_metrics.sql
    │   ├── int_payment_methods_metrics.sql
    │   └── int_payment_metrics.sql
    │
    └── 3_marts
        ├── _mrt_customers.yml
        ├── _mrt_orders.yml
        ├── _mrt_payments.yml
        ├── dim_customers.sql
        ├── fct_orders.sql
        ├── fct_payments.sql
        ├── fct_order_status_metrics.sql
        └── fct_payment_methods_metrics.sql

tests/
└── p1_assert_stg_stripe_payment_total_positive.sql
```

---

## Data Architecture

The project follows a layered architecture inspired by dbt best practices.

### Sources

Raw data ingestion layer.

**Jaffle Shop**

* Customers
* Orders

**Stripe**

* Payments

Source freshness monitoring is configured to ensure data reliability.

### Staging

Data standardization layer responsible for:

* Renaming fields
* Data type corrections
* Business-friendly naming conventions
* Data quality validations
* Source harmonization

Models:

* stg_jaffle_shop__customers
* stg_jaffle_shop__orders
* stg_stripe__payments

### Intermediate

Business logic layer responsible for metric calculations and reusable transformations.

Models:

* int_customers_metrics
* int_orders_metrics
* int_payment_metrics
* int_payment_methods_metrics
* int_order_status_metrics

### Marts

Analytics-ready models consumed by reporting and BI tools.

Models:

* dim_customers
* fct_orders
* fct_payments
* fct_payment_methods_metrics
* fct_order_status_metrics

---

## Data Quality

The project implements several dbt testing strategies to guarantee data reliability.

### Generic Tests

#### Uniqueness

Ensures primary keys remain unique.

* Customer ID
* Order ID
* Payment ID

#### Not Null

Ensures critical business fields are always populated.

#### Relationships

Validates referential integrity across the data model.

Examples:

* Orders → Customers
* Payments → Orders

#### Accepted Values

Validates controlled domains such as:

Order Status:

* completed
* shipped
* placed
* return_pending
* returned

Payment Status:

* success
* fail

Payment Methods:

* credit_card
* gift_card
* coupon
* bank_transfer

### Custom Tests

**p1_assert_stg_stripe_payment_total_positive.sql**

Validates that transformed payment values remain positive after source adjustments.

### Freshness Monitoring

Source freshness checks are configured for all operational datasets.

| Source    | Warning  | Error    |
| --------- | -------- | -------- |
| Orders    | 12 Hours | 24 Hours |
| Customers | 12 Hours | 24 Hours |
| Payments  | 12 Hours | 24 Hours |

---

## Final Data Models

### dim_customers

Customer-level analytical dimension.

Grain:

* One row per customer

Includes customers without orders.

Main metrics:

* Lifetime Value (LTV)
* Average Ticket
* Preferred Payment Method
* Preferred Payment Method Share
* Successful Transactions Count
* Successful Transactions Value
* Failed Transactions Count
* Weighted Average Failed Transaction Value

---

### fct_orders

Order-level fact table.

Grain:

* One row per order

Contains aggregated payment performance indicators linked to each customer order.

---

### fct_payments

Payment transaction fact table.

Grain:

* One row per payment transaction

Represents the lowest level of detail available in the project.

---

### fct_payment_methods_metrics

Customer and payment method performance metrics.

Grain:

* One row per customer and payment method combination

Supports analyses such as:

* Preferred payment methods
* Payment method adoption
* Success and failure rates by payment type

---

### fct_order_status_metrics

Customer and order status performance metrics.

Grain:

* One row per customer and order status combination

Includes:

* First Purchase Date
* Last Purchase Date
* Successful Payment Metrics
* Failed Payment Metrics

---

## Analytical Opportunities

The current source structure enables analyses focused on:

### Customer Value

* Lifetime Value
* Average Ticket
* Purchase Concentration

### Purchase Frequency

* Number of Orders
* First Purchase Date
* Last Purchase Date

### Payment Behavior

* Preferred Payment Method
* Payment Method Share
* Payment Failure Rate
* Payment Success Rate

### Sales Performance

* Successful Sales Volume
* Failed Payment Volume
* Distribution by Order Status
* Distribution by Payment Method

---

## Future Enhancements

The source datasets are intentionally limited and do not currently include demographic, geographic, or product-level information.

Future project iterations may incorporate:

* Customer demographic data
* Geographic segmentation
* Product catalog dimension
* Product category analysis
* RFM segmentation
* Cohort analysis
* Retention metrics
* Incremental models
* CI/CD pipelines
* Automated deployment workflows

---

## Key Learnings

This project was developed to strengthen practical knowledge in:

* Analytics Engineering
* dbt Project Organization
* Layered Data Modeling
* Data Quality Testing
* Source Freshness Monitoring
* Dimensional Modeling
* Business Metric Design
* Customer Analytics
* Payment Analytics
* Documentation Best Practices

---

## Documentation

Project documentation is available through dbt Docs and includes:

* Model descriptions
* Source documentation
* Column-level metadata
* Data lineage
* Test coverage

Generate documentation with:

```bash
dbt docs generate
```

Serve documentation locally:

```bash
dbt docs serve
```

---

## Repository Roadmap

This repository is part of an Analytics Engineering portfolio built using a single dbt project.

Future projects will be organized following the same structure:

```text
models/
├── p1_jaffle_shop
├── p2_<project_name>
├── p3_<project_name>
└── ...
```

Each project will focus on different business domains, datasets, and modeling challenges while maintaining consistent development standards and best practices.

