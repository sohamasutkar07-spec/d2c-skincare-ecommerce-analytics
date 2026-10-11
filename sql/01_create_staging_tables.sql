/*
Project: D2C Skincare E-Commerce Analytics
Dialect: MySQL 8.0+
Purpose: Create staging tables matching the supplied CSV headers.

Run this file first. Then import each CSV into its matching existing table
using MySQL Workbench > Table Data Import Wizard. Do not run the cleaning
and analysis files until all six imports are complete.
*/

CREATE DATABASE IF NOT EXISTS Skincare_analytics;
USE Skincare_analytics;

CREATE TABLE IF NOT EXISTS customer_raw (
    customer_id VARCHAR(10),
    customer_name VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    gender VARCHAR(20),
    age_group VARCHAR(10),
    signup_date VARCHAR(10),
    acquisition_channel VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS orders_raw (
    order_id VARCHAR(10),
    customer_id VARCHAR(10),
    order_date VARCHAR(10),
    order_status VARCHAR(30),
    payment_method VARCHAR(50),
    sales_channel VARCHAR(50),
    gross_amount DECIMAL(10,2),
    discount_amount DECIMAL(10,2),
    shipping_fee DECIMAL(10,2),
    final_amount DECIMAL(10,2),
    delivered_date VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS products_raw (
    product_id VARCHAR(10),
    product_name VARCHAR(150),
    category VARCHAR(50),
    concern VARCHAR(100),
    skin_type VARCHAR(100),
    key_ingredient VARCHAR(100),
    size VARCHAR(20),
    mrp DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    stock_qty INT,
    launch_date VARCHAR(10)
);

/* These column names match Order_Items.csv exactly. */
CREATE TABLE IF NOT EXISTS order_items_raw (
    order_item_id VARCHAR(10),
    order_id VARCHAR(10),
    product_id VARCHAR(10),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount_pct DECIMAL(10,2),
    item_total DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS returns_raw (
    return_id VARCHAR(10),
    order_id VARCHAR(10),
    product_id VARCHAR(10),
    return_date VARCHAR(10),
    return_reason VARCHAR(100),
    refund_status VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS reviews_raw (
    review_id VARCHAR(10),
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    order_id VARCHAR(10),
    rating INT,
    review_date VARCHAR(10)
);

/* CSV import checklist:
   Customers.csv    -> customer_raw
   Orders.csv       -> orders_raw
   Products.csv     -> products_raw
   Order_Items.csv  -> order_items_raw
   Returns.csv      -> returns_raw
   Reviews.csv      -> reviews_raw
*/
