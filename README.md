
# Sales Dashboard

### Dashboard Link : 

## Summary of task

A retailer of office supplies wants to get a better understanding of how their business is performing. They would like a dashboard which allows them to explore their sales by product type, customer and location to identify trends and possible growth areas.

### Steps followed 

- Step 1 : Load data from a csv file into Power BI Desktop.
- Step 2 : Use the Power Query Editor to profile the data, understand what each column shows and identify any anomalies.
- Step 3 : Transform the data using Power Query Editor.
- Step 4 : In the Model view, set up appropriate relationships between tables.
- Step 5 : Create calculated columns and measures as needed.
- Step 6 : In the Report view, add visualizations to summarize the company's sales data.

More detail about the steps taken during this project can be found at the bottom of this document.

# Screenshot of Report

# Insights

### [1] 
           
### [2] 

### [3] 

### [4] 

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
  - Product ID is a key column with 1862 distinct values and 1830 unique values
  - Category has 3 options: "Office Supplies", "Furniture" and "Technology"
  - Subcategory has 17 distinct values
  - Product Name is similar to Product ID but records the name instead. It doesn't have the same distribution suggesting data errors
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
- In order to split the tables, duplicate the Sales table and take the following actions:
  - Rename the new table
  - Select the columns you need to keep and choose the "Remove Other Columns" option
  - Remove duplicates from the new table checking the number is as expected
  - Sort the table if needed
  - Add an index to the new column starting from 1 
  - Rename the new index column
  - These steps will show on the right hand side of the Query Editor
  - ![new table](https://github.com/user-attachments/assets/0c10b885-8b53-4742-a69e-7a785d33f87d)
  - Back on the sales table, use the merge queries option 
  ![merge tables](https://github.com/user-attachments/assets/46bd75b5-28f1-4eb8-aef5-12641cfa1222)
  - Expand the joined table and only keep the key
  - Untick the box to "Use original column name as prefix"
  - Remove the columns that are now in a new table
  - Repeat until all tables have been created
- For the Geography table the expected number of deduped records was 631 because there were 631 unique postal codes. On investigation there was one postal code, 92024, that appeared twice for two different cities. A Google search confirmed this wasn't a data error.
- For the Product table we noted above the distribution of the Product ID and Product Name columns were different. An example is shown below where the same product ID has two different product names.
  ![duplicate values](https://github.com/user-attachments/assets/af455d68-69c5-4461-9560-7b1f02e3165b)
  - These are data errors likely caused by free text data entry
  - Because we want unique Product ID's we'll group by the other three columns and take the max product name (see below)
  ![group by](https://github.com/user-attachments/assets/9bc01e06-ef6a-4731-97d3-322ca113c96c)
  - We now have 1862 distinct Product ID's as required
  - We still have some duplicate product names (see below). These names should have been more descriptive to distinguish one product from another but we can't do much to change this.
  ![duplicate product names](https://github.com/user-attachments/assets/50e7bff9-926a-478d-9227-9705414ee313)


### Step 4: Model the data

### Step 5: Explore the data
- Investigate why some sales have negative or 0 profit
- 

 
        
