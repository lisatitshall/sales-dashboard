
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

# Insights

### [1] Business performance has improved year on year
Sales, profit and orders have generally improved over time except for a dip in sales between 2014 and 2015. In Q4 2017 a number of heavily discounted orders made a loss. This is worth investigation because Q4 is the busiest time of year for this business.

![image](https://github.com/user-attachments/assets/3c7455a3-ac2d-4d4f-9283-7bd9b7dca5e4)

### [2] Wednesdays are the least popular day to place orders
Orders received between Friday and Monday make up roughly the same percentage of all orders, 17-18% each day. The midweek days from Tuesday to Thursday are less popular. The column chart shows this hasn't changed much over the years except in 2014 when Tuesday and Wednesday were more popular and Thursday was less popular. Note: the colours of the bars are conditionally formatted to compare the percentage to the percentage over all years. Surprisingly, there was little difference in when corporate and individual consumers placed their orders. We may have expected corporate clients to not place orders over the weekend.

![popular days](https://github.com/user-attachments/assets/02a60c69-8492-479b-b1aa-dfd1a4085e30)

### [3] Furniture products have the lowest profit margin
When we calculate the overall and average profit margin we see that the furniture category has the lowest overall profit margin. Generally the overall and average profit margins per subcategory are similar but there are notable exceptions, for example, the Supplies subcategory. In the Supplies case we have a positive average profit margin but a negative value overall suggesting a small number of items being sold for a large loss. This was confirmed by looking at the raw data. There is weak negative correlation between the percentage of discounted orders and the average profit margin and no clear trends between category types.

![all profit margin](https://github.com/user-attachments/assets/63f88c90-f894-49b8-a6e0-8e5f2f7cda56)

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
- In the Model View, we can see that all the correct relationships between tables exist
![data model](https://github.com/user-attachments/assets/f0daaa5c-9e7b-476d-85c2-ddd341e5b4e3)



### Step 5: Explore the data
- The following are examples of questions that could help the company understand their current sales and identify potential growth areas:
  - Are profit / sales / orders increasing year on year? By what percentage?
  - What is the relationship between profit and sales?
  - How many days does it take to ship an order that has been placed? Has this been consistent over time? How does it differ by mode?
  - Are there any trends in when products are sold e.g. a season or day of the week?
  - Which product types are the most profitable?
  - Which product types are experiencing the least/most growth year on year?
  - How does performance compare across the different customer types? Is this changing?
  - How do sales compare in different regions? How has this changed over time?
  - How many products are purchased per order?
 
- A lot of these examples rely on analysing trends over time. To do this we introduce a new calendar table using the CALENDARAUTO DAX function.
- Firstly, let's understand whether profit / sales / orders are improving over time.
  To do this we introduce measures like the following which sums up sales for the previous year. Note: the ISBLANK is to ensure we don't have an extra line in the matrix for a year            which has no sales.
  ```
  Last Year Sales = IF(
        NOT ISBLANK([Total Sales]),
        CALCULATE(
            [Total Sales],
            DATEADD('Calendar'[Date], -1, YEAR)
        )
  )
  ```
- The following chart and matrix visualize how the business has performed over time. We note:
  - Sales have increased year on year except for a small dip between 2014 and 2015
  - Profit has increased year on year, even in 2015 when sales dipped. The percentage increase was lower in 2018
  - About 13% of sales end up as profit. This has been fairly stable except in the first trading year where it was 10%
  - Orders have increased year on year. The percentage increase has also improved each year
  ![yearly performance](https://github.com/user-attachments/assets/7a196497-0903-4da9-b56f-9f9862d61a4b)
  - When we drill down on the matrix we see that in Q4 2017 the profit growth is -28% but the sales growth is 19%. When we look at the raw data we see this is due to a number of orders which have a negative profit and a high discount rate.
  ![losing money](https://github.com/user-attachments/assets/3319d0fc-1d5a-4ba2-a329-56ad643af217)
- Next, let's understand whether there are popular days of the week where more orders are likely to be placed.
  To do this we'll introduce the following calculated columns to calculate the weekday an order has been placed on.
  ```
  Day Number of Order = WEEKDAY([Order Date], 1)
  ```
  ```
  Day of Order = FORMAT(Sales[Day Number of Order], "dddd")
  ```
  The Day Number of Order will return an integer from 1 to 7 depending on the day an order was placed. The Day of Order returns the full name of the day. It will be ordered by the Day     Number of Order because otherwise visuals will order the day name alphabetically.

  Then we introduce these two measures. The first calculates the percentage of orders placed on a given day in a given year. The second calculates the percentage of all orders placed on   a given day regardless of the year. Variables have been used for readability.
  ```
  Total Orders Day % of Year = 
    VAR AllOrders = CALCULATE(
        [Total Orders],
        REMOVEFILTERS(Sales[Day Number of Order]),
        REMOVEFILTERS(Sales[Day of Order])
    )
           
    RETURN DIVIDE([Total Orders], AllOrders)
  ```
  ```
  Total Orders % of All Years = 
    VAR AllOrders = CALCULATE(
        [Total Orders],
        REMOVEFILTERS(Sales)
    )

    VAR DayOrders = CALCULATE(
        [Total Orders],
        REMOVEFILTERS(Sales[Year of Order])
    )

    RETURN DIVIDE(DayOrders, AllOrders)

  ```
  To show this visually we'll add this measure and use it for conditional formatting.
  ```
  Order % Colour = IF(
    [Total Orders Day % of Year] < [Total Orders % of All Years], 
    "#59a472",
    "#118DFF"
    
  )                 
  ```
- The following matrix and visual display the results. We note:
  - Wednesday is the least popular day for orders. Only 4% of orders are placed on a Wednesday.
  - There hasn't been much change in popular days over time. The exception is in 2014 when a higher proportion of orders were placed on Tuesdays and Wednesdays.
  - Surprisingly there isn't much difference in which types of customers are placing orders on which day. We might have expected corporate customers to not place orders over the weekend     but that isn't the case.
![popular days](https://github.com/user-attachments/assets/02a60c69-8492-479b-b1aa-dfd1a4085e30)
- Finally, let's look at the overall and average profit margins and how these differ across product categories and subcategories. Note: we don't know whether this profit margin is the net or gross value because we only have a profit figure and no information about whether this excludes the operating costs as well as the cost of goods.
- To calculate the average profit margin we introduce the following measure
  ```
  Average Profit Margin = AVERAGEX(
      Sales,
      [Profit Margin]
  )
  ```
- Adding this to visualizations we get the following. We note:
  - For all categories the overall and average profit margins are both 12%
  - The furniture category has the lowest overall profit margin
  - The table subcategory has the lowest overall profit margin
  - Some subcategories have a large discrepancy between the overall and average profit margin e.g. supplies. In the supplies case we have a positive average profit margin but a        negative value overall. This suggests a small number of items being sold for a large loss which is bringing the overall profit margin down (this is confirmed by looking at the raw data)
![profit margin](https://github.com/user-attachments/assets/a83a3f98-b942-4242-a61f-4814925ecb2b)
- We noted earlier that some items are being sold at a discount. It would be interesting to see whether the proportion of discounted items is correlated to the profit margin. To investigate we add the following measure.
```
  % Discounted Orders = 
  
      VAR DiscountedOrders = CALCULATE(
          [Total Orders], 
          Sales[Discount] > 0
      )
  
      RETURN DIVIDE(DiscountedOrders, [Total Orders])
```
- Adding this to the existing matrix we see that discounts are being applied across all product types. The smallest proportion of discounts are applied to the labels subcategory (35%) and the largest proportion to the chairs and binders subcategories (78%).
- We would expect the average profit margin to be higher if fewer discounts are applied. When we add this to a scatter chart we see there is negative correlation but it's weak. We might also expect product categories to behave similiarly (e.g. form separate clusters on the chart) but this isn't quite true. Furniture products tend to have a higher proportion of discounted orders and a lower average profit margin but the furnishings subcategory doesn't fit this pattern. Likewise for office supplies, the proportion of discounted orders is hovering around 40% but the average profit margin is varying from -16% to 43%
- ![scatter chart](https://github.com/user-attachments/assets/bb04e95d-be85-4ade-befb-14abaddcdb9f)


  


  
  



 
        
