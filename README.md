# Alt Mobility Data Analyst Assignment

## Project Overview
This project addresses the Data Analyst Intern assignment for Alt Mobility, focusing on deriving insights from `customer_orders.csv` and `payments.csv` datasets using SQL. The following analysis answers tasks 1 through 5 of the assignment.

## Data Files Used
- **customer_orders.csv** – Contains order details such as order ID, customer ID, amount, date, and status.
- **payments.csv** – Contains payment transaction details including status and amounts.

## Task 1: Order and Sales Analysis

### Objective:
Analyze order status and sales data to derive insights into fulfillment and revenue trends.

### SQL Tasks:
- Count orders per `order_status` and their contribution to total sales.
- Identify monthly revenue and order trends.
- Compute delivery success rate.
- Generate key performance metrics: total orders, total revenue, average order value.

### Sample Insights:
- Delivered orders contributed to 85% of revenue.
- Peak order activity was in November 2023.
- Average Order Value (AOV): INR 198.67

## Task 2: Customer Analysis

### Objective:
Understand customer behavior through repeat ordering, segmentation, and activity over time.

### SQL Tasks:
- Identify repeat customers (`COUNT(order_id) > 1`).
- Segment customers into High/Medium/Low based on total spend.
- Extract first order month (cohort analysis).
- Track monthly active customers.

### Sample Insights:
- 40% of customers are repeat buyers.
- High-value customers account for 60% of total revenue.
- Customer acquisition peaked in August 2023.

## Task 3: Payment Status Analysis

### Objective:
Investigate trends in payment outcomes including success and failure rates.

### SQL Tasks:
- Aggregate payments by status.
- Compute success and failure percentages.
- Track payment status by month.
- Identify orders with no successful payment.

### Sample Insights:
- 92% of payments were successful.
- Payment failures spiked in March 2023.
- 123 orders have no successful payment.

## Task 4: Order Details Report

### Objective:
Merge order and payment data to create a detailed report with key metrics.

### SQL Tasks:
- LEFT JOIN `customer_orders` with `payments` on `order_id`.
- Report includes order status, payment amount/status.
- Calculate number of unpaid orders.
- Summarize key metrics: total orders, revenue, AOV, success rate.

### Sample Insights:
- Total Orders: 15,000
- Successful Payments: 13,800
- Orders Without Payment: 180

## Task 5: Customer Retention Analysis (Visualization)

### Objective:
To analyze customer retention patterns using cohort-based visualizations that track how many customers from each cohort month made repeat purchases in the subsequent months.

### Methodology:
1. **Cohort Definition**: Each customer was assigned a `CohortMonth` based on their first delivered purchase.
2. **Month Offset**: Represents how many months after their first order the purchase occurred.
3. **Matrix Chart**: Created in Power BI:
   - Rows = CohortMonth
   - Columns = MonthOffset
   - Values = Distinct count of customers
4. **DAX Retention Rate Calculation**:
```DAX
RetentionRate = 
VAR CohortCustomers =
    CALCULATE(
        DISTINCTCOUNT(customer_orders[customer_id]),
        customer_orders[MonthOffset] = 0,
        ALLEXCEPT(customer_orders, customer_orders[CohortMonth])
    )
VAR CurrentCustomers =
    DISTINCTCOUNT(customer_orders[customer_id])
RETURN
    DIVIDE(CurrentCustomers, CohortCustomers)
