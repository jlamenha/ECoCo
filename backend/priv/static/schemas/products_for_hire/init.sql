-- Database: products_for_hire

CREATE TABLE products_for_hire.Discount_Coupons (
    coupon_id INTEGER PRIMARY KEY,
    date_issued TEXT,
    coupon_amount INTEGER
);

CREATE TABLE products_for_hire.Customers (
    customer_id INTEGER PRIMARY KEY,
    coupon_id INTEGER,
    good_or_bad_customer TEXT,
    first_name TEXT,
    last_name TEXT,
    gender_mf TEXT,
    date_became_customer TEXT,
    date_last_hire TEXT
);

CREATE TABLE products_for_hire.Bookings (
    booking_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    booking_status_code TEXT,
    returned_damaged_yn TEXT,
    booking_start_date TEXT,
    booking_end_date TEXT,
    count_hired TEXT,
    amount_payable INTEGER,
    amount_of_discount INTEGER,
    amount_outstanding INTEGER,
    amount_of_refund INTEGER
);

CREATE TABLE products_for_hire.Products_for_Hire (
    product_id INTEGER PRIMARY KEY,
    product_type_code TEXT,
    daily_hire_cost INTEGER,
    product_name TEXT,
    product_description TEXT
);

CREATE TABLE products_for_hire.Payments (
    payment_id INTEGER PRIMARY KEY,
    booking_id INTEGER,
    customer_id INTEGER,
    payment_type_code TEXT,
    amount_paid_in_full_yn TEXT,
    payment_date TEXT,
    amount_due INTEGER,
    amount_paid INTEGER
);

CREATE TABLE products_for_hire.Products_Booked (
    booking_id INTEGER PRIMARY KEY,
    product_id INTEGER,
    returned_yn TEXT,
    returned_late_yn TEXT,
    booked_count INTEGER,
    booked_amount INTEGER
);

CREATE TABLE products_for_hire.View_Product_Availability (
    product_id INTEGER,
    booking_id INTEGER,
    status_date TEXT PRIMARY KEY,
    available_yn TEXT
);

ALTER TABLE products_for_hire.Customers ADD CONSTRAINT fk_Customers_coupon_id_to_Discount_Coupons FOREIGN KEY (coupon_id) REFERENCES products_for_hire.Discount_Coupons(coupon_id);

ALTER TABLE products_for_hire.Bookings ADD CONSTRAINT fk_Bookings_customer_id_to_Customers FOREIGN KEY (customer_id) REFERENCES products_for_hire.Customers(customer_id);

ALTER TABLE products_for_hire.Payments ADD CONSTRAINT fk_Payments_customer_id_to_Customers FOREIGN KEY (customer_id) REFERENCES products_for_hire.Customers(customer_id);

ALTER TABLE products_for_hire.Payments ADD CONSTRAINT fk_Payments_booking_id_to_Bookings FOREIGN KEY (booking_id) REFERENCES products_for_hire.Bookings(booking_id);

ALTER TABLE products_for_hire.Products_Booked ADD CONSTRAINT fk_Products_Booked_product_id_to_Products_for_Hire FOREIGN KEY (product_id) REFERENCES products_for_hire.Products_for_Hire(product_id);

ALTER TABLE products_for_hire.Products_Booked ADD CONSTRAINT fk_Products_Booked_booking_id_to_Bookings FOREIGN KEY (booking_id) REFERENCES products_for_hire.Bookings(booking_id);

ALTER TABLE products_for_hire.View_Product_Availability ADD CONSTRAINT fk_View_Product_Availability_product_id_to_Products_for_Hire FOREIGN KEY (product_id) REFERENCES products_for_hire.Products_for_Hire(product_id);

ALTER TABLE products_for_hire.View_Product_Availability ADD CONSTRAINT fk_View_Product_Availability_booking_id_to_Bookings FOREIGN KEY (booking_id) REFERENCES products_for_hire.Bookings(booking_id);

