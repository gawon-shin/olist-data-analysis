/* ======================================
테이블 생성 (customers, orders, order_items, products)
====================================== */
CREATE TABLE customers (
    customer_id VARCHAR(50),
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(5),
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
CREATE TABLE orders (
    order_id VARCHAR(50),
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);
CREATE TABLE products (
    product_id VARCHAR(50),
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

/* ======================================
 기본키(PK) 설정
====================================== */
ALTER TABLE orders ADD PRIMARY KEY (order_id);
ALTER TABLE customers ADD PRIMARY KEY (customer_id);
ALTER TABLE products ADD PRIMARY KEY (product_id);
ALTER TABLE order_items ADD PRIMARY KEY (order_id, order_item_id);


/* 
======================================
CSV 데이터 적재
import 순서: customers → products → orders → order_items
======================================*/
LOAD DATA LOCAL INFILE
'C:/Users/gawon/Desktop/olist_portfolio/archive/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 
'C:/Users/gawon/Desktop/olist_portfolio/archive/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE
'C:/Users/gawon/Desktop/olist_portfolio/archive/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE
'C:/Users/gawon/Desktop/olist_portfolio/archive/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

/*
======================================
products 컬럼명 정비
원본 CSV 컬럼 오타(lenght → length) 수정
======================================
 */
ALTER TABLE products
CHANGE product_name_lenght product_name_length INT;

ALTER TABLE products
CHANGE product_description_lenght product_description_length INT;

/*
======================================
datetime placeholder 정제
0000-00-00 → NULL 처리 (strict 오류 방지)
======================================
*/
UPDATE orders
SET order_approved_at = NULL
WHERE YEAR(order_approved_at) = 0;
UPDATE orders
SET order_delivered_carrier_date = NULL
WHERE YEAR(order_delivered_carrier_date) = 0;
UPDATE orders
SET order_delivered_customer_date = NULL
WHERE YEAR(order_delivered_customer_date) = 0;


/*
======================================
외래키(FK) 설정
====================================== */

-- orders → customers 
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

-- order_items → orders 
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- order_items → products
ALTER TABLE order_items
ADD CONSTRAINT fk_orderitems_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);
