Create Database superstore_db;
Use superstore_db;

Create Table superstore_campaign
(
	ID Int Primary Key,
    Year_Birth Int Not Null,
    Education Varchar(50),
    Marital_Status Varchar(50),
    Income Int Check (Income >=0),
    Kidhome Int,
    Teenhome Int,
    Dt_Customer Date,
    Recency Int,
    MntWines Int,
    MntFruits Int,
    MntMeatProducts Int,
    MntFishProducts Int,
    MntSweetProducts Int,
    MntGoldProds Int,
    NumDealsPurchases Int,
    NumWebPurchases Int,
    NumCatalogPurchases Int,
    NumStorePurchases Int,
    NumWebVisitsMonth Int,
    Complain Int Check (Complain in (0,1)),
    Response Int Check (Response in (0,1))
);

-- Describing the table fields
Desc superstore_campaign;

-- Total row count
Select Count(*) As Total_Rows
from superstore_campaign;

Select * from superstore_campaign; 

Select Count(*) from superstore_campaign
Where Income = 0;

-- Setting Income which has 0 value as Null. 
Update superstore_campaign
Set Income = null
Where Income = 0;

Select Count(*) 
From superstore_campaign
Where Income is null;

-- Renaming Column name
Alter Table superstore_campaign
Rename Column MntGoldProds To MntGoldProducts;

-- Creating views
Create View Customer_info As
Select 
	ID,
	Year_Birth,
    (Year(curdate()) - Year_Birth) As Age,
	Education,
	Marital_Status,
	Income,
    Kidhome,
    Teenhome,
    (Kidhome + Teenhome) As Total_Children,
    Dt_Customer,
    TimeStampDiff(Year, Dt_Customer,CurDate()) As Tenure
From superstore_campaign;

Select * from Customer_info;

Create View Spending_profile As
Select 
	ID,
    MntWines,
    MntFruits,
    MntMeatProducts,
	MntFishProducts,
    MntSweetProducts,
    MntGoldProducts,
	(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProducts) As Total_Spend,
    Case
		When (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProducts) < 500
             Then 'Low Spending Customer'
		When (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProducts) 
			  Between 500 and 1500 Then 'Moderate Spending Customer'
		Else 'High Spending Customer'
	End as Spend_Category
From superstore_campaign;

Select * from Spending_profile;

Create View Channel_usage As
Select 
	ID,
    NumWebPurchases,
    NumCatalogPurchases,
    NumStorePurchases,
    (NumWebPurchases + NumCatalogPurchases + NumStorePurchases) AS Total_Purchases 
From superstore_campaign;

Select * from Channel_usage;

-- Sanity Queries:

-- Distinct Counts for fields
Select
	   Count(Distinct ID) As Dist_IDs,
	   Count(Distinct Education) As Dist_Education,
       Count(Distinct Marital_Status) As Dist_Marital_Status,
       Count(Distinct Response) As Dist_Response,
       Count(Distinct Complain) As Dist_Complain
From superstore_campaign;

-- Calculating Min/Max for Numeric Columns
Select 
       Min(Id) As Min_Id,
       Max(Id) As Max_Id,
       Min(Year_Birth) As Min_Birth_Year,
       Max(Year_Birth) As Max_Birth_Year,
       Min(Year(CURDATE())- Year_Birth) As Min_Age,
       Max(Year(CURDATE())- Year_Birth) As Max_Age,
       Min(Income) As Min_Income,
       Max(Income) As Max_Income,
       Min(Recency) As Min_Recency,
       Max(Recency) As Max_Recency
From superstore_campaign;

-- Total Spend by all Product categories
Select
		Sum(MntWines) As Total_Wines,
        Sum(MntFruits) As Total_Fruits,
        Sum(MntMeatProducts) As Total_Meat_products,
        Sum(MntFishProducts) As Total_Fish_Products,
        Sum(MntSweetProducts) As Total_Sweet_Products,
        Sum(MntGoldProducts) As Total_Gold_Products
From superstore_campaign;

-- Count of Education Categories
Select Education, Count(*) As Category_Count
From superstore_campaign
Group by Education;

-- Count of Marital_Status Categories
Select Marital_Status, Count(*) As Category_Count
From superstore_campaign
Group by Marital_Status;

-- Spend Category Count
Select Spend_Category, Count(*) as Category_Count
From spending_profile 
Group by Spend_Category;

-- Total Purchases by Product Channel
Select 
	   Sum(NumWebPurchases) As Web,
       Sum(NumCatalogPurchases) As Catalog,
       Sum(NumStorePurchases) As Store
from superstore_campaign;

-- Customer Channel usage 
Select 
SUM(Case When NumWebPurchases >0 Then 1 
         Else 0 End) As Web_Purchasers,
SUM(Case When NumStorePurchases >0 Then 1
		 Else 0 End) As Store_Purchasers,
SUM(Case When NumCatalogPurchases >0 Then 1
		 Else 0 End) As Catalog_Purchasers
From superstore_campaign;

-- Count of Responses
Select Response, Count(*) As Row_Count
From superstore_campaign
Group by Response;

-- Count of Complaints
Select Complain, Count(*) As Row_Count
From superstore_campaign
Group by Complain;
