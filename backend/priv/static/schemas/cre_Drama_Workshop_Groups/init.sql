-- Database: cre_Drama_Workshop_Groups

CREATE TABLE cre_Drama_Workshop_Groups.Ref_Payment_Methods (
    payment_method_code TEXT PRIMARY KEY,
    payment_method_description TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Ref_Service_Types (
    Service_Type_Code TEXT PRIMARY KEY,
    Parent_Service_Type_Code TEXT,
    Service_Type_Description TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Addresses (
    Address_ID INTEGER PRIMARY KEY,
    Line_1 TEXT,
    Line_2 TEXT,
    City_Town TEXT,
    State_County TEXT,
    Other_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Products (
    Product_ID INTEGER PRIMARY KEY,
    Product_Name TEXT,
    Product_Price INTEGER,
    Product_Description TEXT,
    Other_Product_Service_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Marketing_Regions (
    Marketing_Region_Code TEXT PRIMARY KEY,
    Marketing_Region_Name TEXT,
    Marketing_Region_Descriptrion TEXT,
    Other_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Clients (
    Client_ID INTEGER PRIMARY KEY,
    Address_ID INTEGER,
    Customer_Email_Address TEXT,
    Customer_Name TEXT,
    Customer_Phone TEXT,
    Other_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Drama_Workshop_Groups (
    Workshop_Group_ID INTEGER PRIMARY KEY,
    Address_ID INTEGER,
    Currency_Code TEXT,
    Marketing_Region_Code TEXT,
    Store_Name TEXT,
    Store_Phone TEXT,
    Store_Email_Address TEXT,
    Other_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Performers (
    Performer_ID INTEGER PRIMARY KEY,
    Address_ID INTEGER,
    Customer_Name TEXT,
    Customer_Phone TEXT,
    Customer_Email_Address TEXT,
    Other_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Customers (
    Customer_ID INTEGER PRIMARY KEY,
    Address_ID INTEGER,
    Customer_Name TEXT,
    Customer_Phone TEXT,
    Customer_Email_Address TEXT,
    Other_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Stores (
    Store_ID INTEGER PRIMARY KEY,
    Address_ID INTEGER,
    Marketing_Region_Code TEXT,
    Store_Name TEXT,
    Store_Phone TEXT,
    Store_Email_Address TEXT,
    Other_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Bookings (
    Booking_ID INTEGER PRIMARY KEY,
    Customer_ID INTEGER,
    Workshop_Group_ID INTEGER,
    Status_Code TEXT,
    Store_ID INTEGER,
    Order_Date TEXT,
    Planned_Delivery_Date TEXT,
    Actual_Delivery_Date TEXT,
    Other_Order_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Performers_in_Bookings (
    Order_ID INTEGER PRIMARY KEY,
    Performer_ID INTEGER
);

CREATE TABLE cre_Drama_Workshop_Groups.Customer_Orders (
    Order_ID INTEGER PRIMARY KEY,
    Customer_ID INTEGER,
    Store_ID INTEGER,
    Order_Date TEXT,
    Planned_Delivery_Date TEXT,
    Actual_Delivery_Date TEXT,
    Other_Order_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Order_Items (
    Order_Item_ID INTEGER PRIMARY KEY,
    Order_ID INTEGER,
    Product_ID INTEGER,
    Order_Quantity TEXT,
    Other_Item_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Invoices (
    Invoice_ID INTEGER PRIMARY KEY,
    Order_ID INTEGER,
    payment_method_code TEXT,
    Product_ID INTEGER,
    Order_Quantity TEXT,
    Other_Item_Details TEXT,
    Order_Item_ID INTEGER
);

CREATE TABLE cre_Drama_Workshop_Groups.Services (
    Service_ID INTEGER PRIMARY KEY,
    Service_Type_Code TEXT,
    Workshop_Group_ID INTEGER,
    Product_Description TEXT,
    Product_Name TEXT,
    Product_Price INTEGER,
    Other_Product_Service_Details TEXT
);

CREATE TABLE cre_Drama_Workshop_Groups.Bookings_Services (
    Order_ID INTEGER,
    Product_ID INTEGER,
    PRIMARY KEY (Order_ID, Product_ID)
);

CREATE TABLE cre_Drama_Workshop_Groups.Invoice_Items (
    Invoice_Item_ID INTEGER PRIMARY KEY,
    Invoice_ID INTEGER,
    Order_ID INTEGER,
    Order_Item_ID INTEGER,
    Product_ID INTEGER,
    Order_Quantity INTEGER,
    Other_Item_Details TEXT
);

ALTER TABLE cre_Drama_Workshop_Groups.Clients ADD CONSTRAINT fk_Clients_Address_ID_to_Addresses FOREIGN KEY (Address_ID) REFERENCES cre_Drama_Workshop_Groups.Addresses(Address_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Drama_Workshop_Groups ADD CONSTRAINT fk_Drama_Workshop_Groups_Address_ID_to_Addresses FOREIGN KEY (Address_ID) REFERENCES cre_Drama_Workshop_Groups.Addresses(Address_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Performers ADD CONSTRAINT fk_Performers_Address_ID_to_Addresses FOREIGN KEY (Address_ID) REFERENCES cre_Drama_Workshop_Groups.Addresses(Address_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Customers ADD CONSTRAINT fk_Customers_Address_ID_to_Addresses FOREIGN KEY (Address_ID) REFERENCES cre_Drama_Workshop_Groups.Addresses(Address_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Stores ADD CONSTRAINT fk_Stores_Marketing_Region_Code_to_Marketing_Regions FOREIGN KEY (Marketing_Region_Code) REFERENCES cre_Drama_Workshop_Groups.Marketing_Regions(Marketing_Region_Code);

ALTER TABLE cre_Drama_Workshop_Groups.Stores ADD CONSTRAINT fk_Stores_Address_ID_to_Addresses FOREIGN KEY (Address_ID) REFERENCES cre_Drama_Workshop_Groups.Addresses(Address_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Bookings ADD CONSTRAINT fk_Bookings_Workshop_Group_ID_to_Drama_Workshop_Groups FOREIGN KEY (Workshop_Group_ID) REFERENCES cre_Drama_Workshop_Groups.Drama_Workshop_Groups(Workshop_Group_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Bookings ADD CONSTRAINT fk_Bookings_Customer_ID_to_Clients FOREIGN KEY (Customer_ID) REFERENCES cre_Drama_Workshop_Groups.Clients(Client_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Performers_in_Bookings ADD CONSTRAINT fk_Performers_in_Bookings_Order_ID_to_Bookings FOREIGN KEY (Order_ID) REFERENCES cre_Drama_Workshop_Groups.Bookings(Booking_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Performers_in_Bookings ADD CONSTRAINT fk_Performers_in_Bookings_Performer_ID_to_Performers FOREIGN KEY (Performer_ID) REFERENCES cre_Drama_Workshop_Groups.Performers(Performer_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Customer_Orders ADD CONSTRAINT fk_Customer_Orders_Store_ID_to_Stores FOREIGN KEY (Store_ID) REFERENCES cre_Drama_Workshop_Groups.Stores(Store_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Customer_Orders ADD CONSTRAINT fk_Customer_Orders_Customer_ID_to_Customers FOREIGN KEY (Customer_ID) REFERENCES cre_Drama_Workshop_Groups.Customers(Customer_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Order_Items ADD CONSTRAINT fk_Order_Items_Product_ID_to_Products FOREIGN KEY (Product_ID) REFERENCES cre_Drama_Workshop_Groups.Products(Product_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Order_Items ADD CONSTRAINT fk_Order_Items_Order_ID_to_Customer_Orders FOREIGN KEY (Order_ID) REFERENCES cre_Drama_Workshop_Groups.Customer_Orders(Order_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Invoices ADD CONSTRAINT fk_Invoices_payment_method_code_to_Ref_Payment_Methods FOREIGN KEY (payment_method_code) REFERENCES cre_Drama_Workshop_Groups.Ref_Payment_Methods(payment_method_code);

ALTER TABLE cre_Drama_Workshop_Groups.Invoices ADD CONSTRAINT fk_Invoices_Order_ID_to_Bookings FOREIGN KEY (Order_ID) REFERENCES cre_Drama_Workshop_Groups.Bookings(Booking_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Invoices ADD CONSTRAINT fk_Invoices_Order_ID_to_Customer_Orders FOREIGN KEY (Order_ID) REFERENCES cre_Drama_Workshop_Groups.Customer_Orders(Order_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Services ADD CONSTRAINT fk_Services_Service_Type_Code_to_Ref_Service_Types FOREIGN KEY (Service_Type_Code) REFERENCES cre_Drama_Workshop_Groups.Ref_Service_Types(Service_Type_Code);

ALTER TABLE cre_Drama_Workshop_Groups.Services ADD CONSTRAINT fk_Services_Workshop_Group_ID_to_Drama_Workshop_Groups FOREIGN KEY (Workshop_Group_ID) REFERENCES cre_Drama_Workshop_Groups.Drama_Workshop_Groups(Workshop_Group_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Bookings_Services ADD CONSTRAINT fk_Bookings_Services_Product_ID_to_Services FOREIGN KEY (Product_ID) REFERENCES cre_Drama_Workshop_Groups.Services(Service_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Bookings_Services ADD CONSTRAINT fk_Bookings_Services_Order_ID_to_Bookings FOREIGN KEY (Order_ID) REFERENCES cre_Drama_Workshop_Groups.Bookings(Booking_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Invoice_Items ADD CONSTRAINT fk_Invoice_Items_to_Bookings_Services FOREIGN KEY (Order_ID, Product_ID) REFERENCES cre_Drama_Workshop_Groups.Bookings_Services(Order_ID, Product_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Invoice_Items ADD CONSTRAINT fk_Invoice_Items_Invoice_ID_to_Invoices FOREIGN KEY (Invoice_ID) REFERENCES cre_Drama_Workshop_Groups.Invoices(Invoice_ID);

ALTER TABLE cre_Drama_Workshop_Groups.Invoice_Items ADD CONSTRAINT fk_Invoice_Items_Order_Item_ID_to_Order_Items FOREIGN KEY (Order_Item_ID) REFERENCES cre_Drama_Workshop_Groups.Order_Items(Order_Item_ID);

