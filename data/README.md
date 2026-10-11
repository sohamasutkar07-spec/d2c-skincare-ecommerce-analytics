# Source data files

Copy the six supplied synthetic CSV files into this folder before running the import steps:

- Customers.csv
- Orders.csv
- Order_Items.csv
- Products.csv
- Returns.csv
- Reviews.csv

The table schemas and import mapping are documented in sql/01_create_staging_tables.sql and the top-level README. Import each CSV into the matching existing raw table using MySQL Workbench's Table Data Import Wizard.

The dataset is synthetic and intended for educational portfolio use. It does not represent official company data.