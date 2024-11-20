
# Sales Dashboard

### Dashboard Link : 

## Problem Statement

A retailer of office supplies wants to get a better understanding of how their business is performing. They would like a dashboard which allows them to explore their sales by product type, customer and location to identify trends and possible growth areas.

### Steps followed 

- Step 1 : Load data from a csv file into Power BI Desktop.
- Step 2 : Use the Power Query Editor to profile the data, understand what each column shows and identify any anomalies.
- Step 3 : Transform the data using Power Query Editor.
- Step 4 : In the Model view, set up appropriate relationships between tables.
- Step 5 : Create calculated columns and measures as needed.
- Step 6 : In the Report view, add visualizations to summarize the company's sales data.

## Detailed steps

### Step 1: Load data into Power BI Desktop
- In Power BI Desktop, click Get Data > Text/CSV to select the csv document
- View the data preview to see which columns will be loaded
![data preview](https://github.com/user-attachments/assets/2bda8611-0419-4951-b190-eed1cba9cea3)
- Click Transform to open the Power Query Editor

### Step 2: Use Power Query Editor to profile the data
- Check that the datatypes for each column are suitable
- Because we have US data the postcode is recognised as a number. We won't do any calculations on this column so change it to text.
![data types](https://github.com/user-attachments/assets/0bf68141-87c4-48d6-89a8-7c0af123dcf9)
- Rename the query to Sales
- In the View tab click the following tickboxes to profile the data
  - Column Quality
  - Column Distribution
  - Column Profile
- At the bottom of the screen change the setting so the profiling is based on the whole dataset
![data profiling](https://github.com/user-attachments/assets/ba0eed76-2348-49b2-88dc-286ba2615f21)
- Draw conclusions about each column
  - Row ID is an integer from 1 to 9994 (the total number of rows). Each value is unique
  - Order ID is not unique. Multiple products can be linked to one order
  - Order Date ranges from 03/01/2014 to 30/12/2017
  - Ship Date ranges from 07/01/2014 to 05/01/2018. This is a few days after the Order Date which makes sense
  - Ship Mode is a category column with 4 options: "Standard Class", "Second Class", "First Class" and "Same Day"
  - Customer ID is a text column. There are 793 customers and 5 values only appear once
  - Customer Name has the same distribution as Customer ID but records the name instead
  - Segment is a category column with 3 options: "Consumer", "Corporate" and "Home Office"
  - Country is always United States
  - City is a text column. There are 531 distinct cities and 70 values only appear once
  - State is a text column. There are 49 distinct states and 1 value only appears once. This is almost all the US states.
  - Postal Code is a 5-letter text column with 631 distinct values
  - Region is a category column with 4 options: "West", "East", "Central" and "South"
  - Product ID is a key column with 1862 distinct values
  - Category has 3 options: "Office Supplies", "Furniture" and "Technology"
  - Subcategory has 17 distinct values
  - Product Name is similar to Product ID but records the name instead. It doesn't have the same distribution suggesting a few data errors
  - Sales is a decimal column with min 0.44, average 229.85 and max 22638
  - Quantity is an integer column with min 1 and max 14
  - Discount is a decimal column recording the percentage discount applied on the sale. Most sales have 0 discount. The max is 0.8.
  - Profit is a decimal column. It's noteworthy that some values are negative and some are 0. We can investigate these later.
- Determine whether there are any missing values or errors in the data
  - All columns have 0% for error and empty

### Step 3: Transform the data
- Split the data into the following tables:
  - Sales - Row ID, Order ID, Order Date, Ship Date, Ship Mode Key, Customer Key, Geography Key, Product Key, Sales, Quantity, Discount, Profit
  - Customer - Customer Key, Customer ID, Customer Name, Segment
  - Geography - Geography Key, Country, City, State, Postal Code, Region
  - Product - Product Key, Product ID, Category, Subcategory, Product Name
  - Ship Mode - Ship Mode Key, Ship Mode
- Investigate the difference in distribution between Product ID and Product Name
- Investigate why some sales have negative or 0 profit
# Screenshot of Report

![sales dashboard](https://github.com/user-attachments/assets/365a1fbe-3e5c-4a36-89cb-d8e3d5f7a226)

# Insights

### [1] 
           
### [2] 

### [3] 

### [4] 
 
        
