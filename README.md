# DBT
## Source DAG

![Source DAG](./Images/Source%20DAG.png)

## Schema DAG

![Schema DAG](./Images/Schema%20DAG.png)

## Snowflake 

![Snowflake](./Images/Snowflake.png)

##Snowflake Script

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





