# **DBT Project: Data Transformation using Snowflake and GitHub**

## **Overview**
This project demonstrates how to set up and manage a **dbt (Data Build Tool) project** with **Snowflake** as the data warehouse and **GitHub** for version control. It covers:
- Loading raw data from CSV files into Snowflake.
- Transforming data using dbt with **staging, intermediate, and marts layers**.
- Connecting **dbt Cloud** to **Snowflake** and **GitHub**.
- Implementing **data quality checks** and best practices.

---

## **Data Source**
The **data** folder in the repository contains four CSV files:
- `customers.csv`
- `orders.csv`
- `order_items.csv`
- `products.csv`

## **Snowflake Setup**
Run the following SQL script in Snowflake Worksheets to create the required database, schema, stage and tables:
```
CREATE DATABASE mydatabase;

USE DATABASE mydatabase;

CREATE SCHEMA myschema;

CREATE OR REPLACE TABLE mydatabase.myschema.customers (
    customer_id INT PRIMARY KEY,
    first_name STRING,
    last_name STRING,
    email STRING,
    created_at TIMESTAMP
);

CREATE OR REPLACE TABLE mydatabase.myschema.orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES mydatabase.myschema.customers(customer_id),
    order_date DATE,
    order_status STRING,
    total_amount FLOAT
);

CREATE OR REPLACE TABLE mydatabase.myschema.order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT REFERENCES mydatabase.myschema.orders(order_id),
    product_id INT,
    quantity INT,
    unit_price FLOAT
);

CREATE OR REPLACE TABLE mydatabase.myschema.products (
    product_id INT PRIMARY KEY,
    product_name STRING,
    category STRING,
    price FLOAT
);

CREATE OR REPLACE FILE FORMAT mydatabase.myschema.CSV_Format
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
ERROR_ON_COLUMN_COUNT_MISMATCH = TRUE;

CREATE OR REPLACE STAGE mydatabase.myschema.raw_stage
FILE_FORMAT = mydatabase.myschema.CSV_Format;

LIST @mydatabase.myschema.raw_stage;

USE SCHEMA myschema;

LIST @raw_stage;

COPY INTO mydatabase.myschema.customers 
FROM @raw_stage/customers.csv file_format=CSV_Format PATTERN = '.*\.csv*' ON_ERROR='SKIP_FILE';


COPY INTO mydatabase.myschema.orders 
FROM @mydatabase.myschema.raw_stage/orders.csv file_format=CSV_Format PATTERN = '.*\.csv*' ON_ERROR='SKIP_FILE';

COPY INTO mydatabase.myschema.order_items 
FROM @mydatabase.myschema.raw_stage/order_items.csv file_format=CSV_Format PATTERN = '.*\.csv*' ON_ERROR='SKIP_FILE';

COPY INTO mydatabase.myschema.products 
FROM @mydatabase.myschema.raw_stage/products.csv file_format=CSV_Format PATTERN = '.*\.csv*' ON_ERROR='SKIP_FILE';

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM products;

show tables in mydatabase.myschema;

```


## **Connecting dbt Cloud to Snowflake & GitHub**
To set up dbt Cloud with Snowflake and GitHub, follow these steps:
1. **Create a dbt Cloud account** and start a new project.
2. In **dbt Cloud**, go to **Account Settings** → **Integrations** → **Connect to Snowflake**.
3. Enter your **Snowflake credentials**:
   - Account (Dev Snowflake account; `<this>.snowflakecomputing.com`)
   - User name
   - Password
   - Database (`mydatabase`)
   - Schema (`myschema`)
   - Warehouse name (`COMPUTE_WH`)
4. Click **Test Connection** to verify the setup.
5. Initialize dbt project and define models.


## **dbt Project Structure**

```plaintext   
models/
  ├── staging/
  │   ├── schema.yml
  │   ├── stg_customers.sql
  │   ├── stg_order_items.sql
  │   ├── stg_orders.sql
  │   ├── stg_products.sql
  ├── intermediate/
  │   ├── schema.yml
  │   ├── int_order_revenue.sql
  │   ├── int_orders.sql
  ├── marts/
  │   ├── schema.yml
  │   ├── dim_customers.sql
  │   ├── fct_order_revenue.sql
  │   ├── fct_orders.sql
  ├── sources.yml
packages.yml
dbt_project.yml
  
test/
  ├── generic/
  │   ├── is_positive.sql
 ```

## **Running dbt Commands**

After setting up dbt Cloud, execute the following commands:

#### **1. Verify Connection to Snowflake**
```
dbt debug
```
#### **2. Install Dependencies**
```
dbt deps
```
#### **3. Run Models & Transform Data**
```
dbt run
```
#### **4. Run Data Tests**
```
dbt test
```
#### **5. Build Models & Run Tests**
```
dbt build
```
## **Data Modeling & Transformation**

### **Tasks:**

#### **1. Staging Models:**
- Create separate staging models for each raw table.
- Rename columns (e.g., `customer_id → cust_id`).
- Convert string fields to lowercase.
- Remove records with NULL primary keys.

#### **2. Intermediate Models:**
- `int_orders`: Join orders with customers & add `customer_full_name`.
- `int_order_revenue`: Join order_items with products to calculate total revenue.

#### **3. Final Models (Marts Layer):**
- `fct_orders`: Contains key order details.
- `fct_order_revenue`: Aggregates revenue per order.
- `dim_customers`: Stores customer information.

#### **4. Data Tests:**
- Ensure **Primary Key Uniqueness** (`customer_id`, `order_id`, `product_id`).
- Ensure **Non-Null Values** (`customer_id`, `order_id`, `total_amount`).
- Custom test to ensure `total_revenue > 0` in `fct_order_revenue`.
---
## **Visualizing the Data Pipeline**

### Source DAG

![Source DAG](./Images/Source%20DAG.png)

### Schema DAG

![Schema DAG](./Images/Schema%20DAG.png)

### Snowflake 

![Snowflake](./Images/Snowflake.png)

## **Conclusion**
This project demonstrates how to load, transform, and test data using dbt Cloud with Snowflake. It follows best practices for data modeling, pipeline orchestration, and GitHub integration.

## **License**
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.





