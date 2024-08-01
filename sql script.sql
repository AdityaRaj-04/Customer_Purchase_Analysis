# CREATE DATABASE
create database Retails;

use retails;

# CREATE CUSTOMERS TABLE
create table retails.customers ( customerid int primary key, firstname varchar(50), lastname varchar(50), country varchar(50));

# CREATE PRODUCTS TABLE
create table Retails.products ( productid int primary key, product_name varchar(50), product_Category varchar(100), product_quantity int);

# CREATE PURCHASE TABLE AND DESIGN SCHEMA
create table retails.purchase ( transactionid int primary key, customerid int, productid int, purchase_price decimal(10, 2), purchase_date date, 
foreign key (customerid) references customers(customerid), 
foreign key (productid) references products(productid));

# IMPORT DATA INTO NORMALIZED TABLE
insert ignore into customers (customerid, firstname, lastname, country)
select distinct customerid, firstname, lastname, country from customer_purchase_data;

SELECT* FROM CUSTOMERS;

insert ignore into products (productid, product_name, product_category, product_quantity) 
select distinct productid, product_name, product_category, product_quantity from customer_purchase_data;
select* from products;

insert into purchase (transactionid, customerid, productid, purchase_price, purchase_date)
select transactionid, customerid, productid, purchase_price, purchase_date from customer_purchase_data;
select * from purchase;

# CHECK CUSTOMERS DATA
select * from customers;

# CHECK PRODUCTS DATA
select * from products;

#CHECK PURCHASE DATA
select * from purchase;

# HANDLE MISSING VALUES AND DATA QUALITY
select * from purchase 
where customerid not in (select customerid from customers)
or productid not in (select productid from products)
or transactionid not in (select transactionid from purchase);

# HANDLE MISSIONG VALUES
SET SQL_SAFE_UPDATES = FALSE;

DELETE FROM Purchase
WHERE CustomerID IS NULL
   OR ProductID IS NULL
   OR Purchase_Price IS NULL
   OR Purchase_Date IS NULL;


# CREATE RELATIONSHIP
  ALTER TABLE Purchase
ADD CONSTRAINT fk_customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

  ALTER TABLE Purchase
ADD CONSTRAINT fk_products
FOREIGN KEY (productID) REFERENCES products(ProductID);

# TOTAL PURCHASE PER CUSTOMERS

select purchase.customerid, customers.firstname, customers.lastname, 
sum(products. product_quantity) as totalquantity, 
sum(purchase.purchase_price * products.product_quantity) as totalsales
from 
purchase
join 
customers on customers.customerid = purchase.customerid
join
products on products.productid = purchase.productid
group by
purchase.customerid, customers.firstname, customers.lastname
limit 0, 1000;

# TOTAL SALES PER PRODUCT
SELECT 
    p.ProductID, 
    pr.Product_Name, 
    SUM(pr.product_Quantity) AS TotalQuantity, 
    SUM(p.Purchase_Price * pr.product_Quantity) AS TotalSales
FROM 
    Purchase AS p
JOIN 
    Products AS pr ON p.ProductID = pr.ProductID
GROUP BY 
    p.ProductID, pr.Product_Name
LIMIT 0, 1000;

# TOATL SALES PER COUNTRY
SELECT 
    c.Country, 
    SUM(p.Purchase_Price * pR.PRODUCT_Quantity) AS TotalSales
FROM 
    Purchase AS p
JOIN 
    CUSTOMERS AS c ON p.CUSTOMERID = c.CUSTOMERID
JOIN
	PRODUCTS AS PR ON PR.PRODUCTID = P.PRODUCTID
GROUP BY 
    c.CountrY
LIMIT 0, 1000;