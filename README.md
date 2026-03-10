# Retail Stock-out & Lost Sales Analysis
This project demonstrate how I approach a real retail/supply-chain problem end-to-end: modelling the data, defining KPIs, and producing outputs that are usable for business decision-making.

## Business problem
Stock-outs reduce sales and damage customer experience. The goal here is to identify stock-out episodes and estimate lost sales impact across stores and products.

## Objectives
- Detect stock-out episodes
- Build availability KPIs
- Estimate lost sales using a transparent baseline approach
- Identify highest-impact stores/SKUs and recommend actions

## Dataset
M5 Forecasting - Accuracy (Walmart):
- Daily unit sales by item and store
- Calendar table (date mapping + week keys)
- Weekly sell prices 

## Assumptions and limitations
The M5 dataset does not include inventory-on-hand data. Because of this, stock-outs cannot be directly observed.  
This project therefore uses a rule-based proxy to identify potential stock-out signals based on daily sales patterns, recent sales history, and zero-sales episodes.
These results should be interpreted as indicators of where to investigate, not as audited stock-out events.

## Approach
1) Load raw CSV files into DuckDB
2) Transform sales from wide format (d_1..d_1913) into a daily fact table
3) Create features (prev 7d avg, prev 28d avg, days with sales in last 28d)
4) Apply a rule-based signal (Rule B)
5) Convert signal days into stock-out episodes
6) Estimate lost sales:
   - Lost units (proxy): max(0, baseline - actual), baseline = prev_28d_avg
   - Lost revenue (proxy): lost_units × weekly sell_price

## Signal rule (Rule B)
A day is flagged as a signal when:
- units = 0
- days_with_sales_last_28d >= 10
- prev_28d_avg >= 1.0

## Outputs
- stockout_episodes: episode start/end/duration
- lost_sales_episode: lost units (proxy)
- lost_revenue_episode: lost revenue (proxy)
- store_lost_revenue_summary: store ranking by revenue impact
- item_lost_revenue_summary: SKU ranking by revenue impact

