
# Mint Classics Company: A Model Car Database Analytics with MySQL Workbench and Tableau Public Dashboard

Date: February 6, 2025 Author: Vesela Velikova

#### Table of Contents
- <a href="#overview" id="toc-overview">Overview</a>
  - <a href="#data-structure" id="toc-data-structure">Data Structure</a>
  - <a href="#technical-details" id="toc-technical-details">Technical details</a>
- <a href="#executive-summary" id="toc-executive-summary">Executive summary</a>
  - <a href="#overview-of-findings" id="toc-overview-of-findings">Overview of Findings</a>
    - <a href="#sale-trends-key-insights" id="sale-trends-key-insights">Sale Trends Key Insights</a>
    - <a href="#product-performance-key-insights" id="product-performance-key-insights">Product performance Key Insights</a>
    - <a href="#shipping-time-and-status-key-insights" id="shipping-time-and-status-key-insights">Shipping Time and Status Key Insights</a>
- <a href="#recommendations" id="toc-recommendations">Recommendations</a>
- <a href="#caveats-and-assumptions" id="toc-caveats-and-assumptions">Caveats And Assumptions</a>

## **Overview**

Mint Classics Company is a retailer of classic model cars and other vehicles. They own four storage facilities and maintain a large product range.  
The company is providing the Mint Classics relational database to uncover key insights. This will help the company make inventory-related business decisions that lead to the closure of a storage facility. The stakeholders are asking to take into account that their desire is to ship a product to a customer within 24 hours of the order being placed.

This project aimed to analyze the warehouse performance, product performance, timely shipping and sales trends. 

Insights and recommendations are provided on the following key areas:

 - **Warehouse Key Performance Indicators (KPIs) and performance.** Turn Over Ratio, Evaluation of inventory levels - stock to sales ratio, distribution of product lines through the warehouses and dead stock. Focusing on the revenue.
 - **Sale trends analysis.** How are inventory numbers related to sales figures? What are the products with the most sales, and which are the least sold items. Are there products that are not moving?
 - **Shipping trends.** Analysing if the desired 24 hours shipping window is met.


  ### **Data Structure**

This is a screenshot of the Mint Classics relational database and a relational data model and EER (Extended Entity-Relationship) diagram that models its structure. It contains nine tables. 

![Screenshot of a EER of the Mint Classics relational database](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/mint-classics-database-EER.jpg)


  ### **Technical details**

 - MySQL Workbench is used for database management and advanced data manipulation. All SQL queries can be found [here](https://github.com/veselaDV/mint-classics-database/blob/main/sql-queries)
 - Google spreadsheets are used for some data cleaning, transformation and advanced exploratory analysis EDA via pivot tables, conditional formatting and data validation. Screenshots of the tables and diagrams can be found [here](https://github.com/veselaDV/mint-classics-database/tree/main/screenshots-diagrams-dashboards).
 - [Tableau Public Dashboard](https://public.tableau.com/views/MintClassicsCompany-InventoryandWarehouseAnalysisDashboard/Dashboard5?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) is used to support the findings and conclusions by visualizing the data.


## **Executive summary**

The Mint Classic company is in need of information about how their warehouses are operating. To support the stakeholders of the company in making a data-driven decision Tableau public dashboard is made. The examples of the Tableau public dashboard are included through the report.  


  ### **Overview of Findings**

  The two warehouses with the lowest revenue are the South warehouse with revenue of 1 876 645 or **20% of total revenue** and **Turn Over Ratio (TOR) of 544.1**. West warehouse with revenue of 1 797 560 or **19% of total revenue** and **TOR of 343.4**. The East warehouse is the best performer considering that the sales of its product lines made **40% of the total revenue** for the analyzed period and **TOR of 665.8**.
There is correlation between the underperformance of the South warehouse and the type of the product lines it holds. The product lines with the **lowest sales** are: **Trains (6%)**, **Ships (1%)** and **Trucks & Buses (10%)**. The Classic cars product line held by East warehouse makes 40% of all revenue. 
The **inventory turnover period** for all warehouses is **between 1.3 to 2.5** - highest for West warehouse (2.5) and North warehouse (2.2). This indicates that the company sells and replaces its entire inventory 1.9 times on average over the course of the specified time period (jan 2003 - may 2005), which could indicate slow sales or overstocking issues. 
The average **inventory to sales ratio (I/S)** of **0.1**, that is less than the desired range of 0.17 to 0.25. This may be an indicator that inventory is selling too quickly to fulfill the demand.
Regarding the stock and capacity the South warehouse holds the least amount of **products (79 380, 14% of all stock)** and its capacity utilization is 75%. The East warehouse holds 39% of all stock at 67% capacity utilization.
The shipping efficiency exceeds the desired shipping window of 24 hours. The **fulfillment times** on average are **between 11 and 14 days**. Products with insufficient stock levels play a crucial role in shipping windows and customer satisfaction.

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/KPIs%20Dashboard.png)


   #### **1. Sale Trends Key Insights**
Analyzing Sale trends shows that there is a strong seasonality at the end of the year (**October and November**). The company can look for the opportunity for inventory management ahead of these peak periods.

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/Seasonality%20-%20Revenue%20by%20year%20for%20each%20warehouse%20.png)

The Product lines with the most sales are situated in East and West Warehouses, respectively **$3.8M** for the Classic Cars product line and **$1.8M** for the Vintage Cars product line. The South Warehouse holds the product lines with the least sales: Trains ($0.19M), Ships ($0.66M) and Trucks & Buses ($1.02M).
 
![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/Revenu%20by%20Warehouse%20and%20Product%20Line.png)


   #### **2. Product performance Key Insights**

Our product performance analysis reveals a need for improvement regarding the availability of the products being sold and problems with overstocking items that did not sell well.
There are products with high sales and low or insufficient stock. This leads to shipping delays and client dissatisfaction.

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/products-inventory-volume.jpg)

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/Top-5-Products-High-Sales-Low-Inventory.png)

On the other hand there are products with high quantity in stock and low sales. 

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/Top%205%20Products%20with%20Low%20Sales%20and%20High%20Inventory.png)

The analysis shows one product with **Product Code S18_3233** 1985 Toyota Supra with **0 sales** for the period of 2003 to may 2005, and **stock of 7733 units**. This suggests that the product should be discontinued and the remaining stock should be object to promotion or discount.
**Product Code S18_3232 - 1992** Ferrari 360 Spider red is the product with the **most sales** with **1808 units sold** and of **276 839 revenue** for the analyzed period.
Warehouse Capacity and Stock Key Insights
The average **inventory to sales ratio of 0.1** can be an indicator that inventory is selling too quickly to fulfill the demand. This insight is consistent with the product analysis that shows there are products in high demand facing insufficient inventory.

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/Inventory%20to%20Sales%20Ratio.png)

Regarding the stock and capacity the South warehouse holds the least amount of products (79.4K or 14% of all stock held by the company). Its capacity utilization is 75%. East warehouse holds 39% of all stock at 67% capacity utilization. 

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/Dash%20Stock%20and%20Capacity%20Trends%20by%20Warehouse.png)

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/Stock%20and%20Capacity%20Trends%20by%20Warehouse.png)

   #### **3. Shipping Time and Status Key Insights**
The company faces difficulties with meeting the desired shipping window of 24 hours per order. Average shipping window for an order is 13 days. This is consistent in all warehouses.

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/avg.%20days%20of%20shipping.png)

The cancellation of orders is more concentrated in the South warehouse (4% of all orders). The company should investigate further on the reasons for cancellations.

![Screenshot of KPIs Tableau Public Dashboard](https://github.com/veselaDV/mint-classics-database/blob/main/screenshots-diagrams-dashboards/Shipping%20Status%20by%20Warehouse.png)

## **Recommendations**

Based on the uncovered insights, the following recommendations have been provided:
- Considering its revenue (**20% of total revenue**), quantity of stored products (**14% of all stock**) and the total number of sales of the carried product lines: **Trains (6% of all sales)**, **Ships (1% of all sales)** and **Trucks & Buses (10% of all sales)**, the most favorable choice for eliminating is the **South warehouse**. Its inventory can be redistributed between the two warehouses with lower taken capacity - **East (67%)** and **West (50%)**.
- In the future, it is recommended that product lines be distributed equally between operating warehouses, with orders arriving at the closest to the shipping address warehouse. This way the company can ensure more efficient delivery times.
- In order to reduce storage costs and increase working capital more effective Inventory management is needed. Considering promotions/discounts for the overstock inventory, and discontinuing products that **never made sales** (1985 Toyota Supra with **product code S18_3233**).
- Optimize Inventory Levels. The low/insufficient stock to sales ratio of products (**top 5** products with **insufficient stock**: product codes S24_2000, S12_1099, S32_4289, S32_1374, S72_3212) is increasing the chances of canceled orders and shipment delays due to low/insufficient stock. This optimization reduces the risk of stockouts and ensures that products are available when customers need them.
- Sales trends show **seasonality** over the months of **October** and **November**. The company should consider taking relevant marketing and advertising actions to boost sales during the dead period (December to October).
- Centralizing the warehouse data may provide the company with a blueprint to work around to ensure all departments are aligned. This results in improved data integrity, and valuable tracking and reporting. 

  ### **Caveats And Assumptions**

During the analysis, certain limitations were encountered:
- The dataset contains data from 2003, 2004 through may 2005. There are missing values for 2004. This prevents the analysis from being thorough. The lack of yearly trends lower the integrity of the driven insights for the measured KPIs.
- Incomplete or missing data regarding products and orders details that could affect the analysis.
- Assumptions were made regarding the location of the warehouses. Factors affecting shipping times and shipping cost were not accounted for.
- Assumptions were made regarding sales trends based on available data.

**Contrybution** Analyze Data in a Model Car Database with MySQL Workbench a [Coursera Project](https://www.coursera.org/projects/showcase-analyze-data-model-car-database-mysql-workbench) 
