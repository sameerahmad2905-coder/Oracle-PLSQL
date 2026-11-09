CREATE TABLE CUSTOMERS (
    CUSTOMER_ID     NUMBER(6) PRIMARY KEY,
    FIRST_NAME      VARCHAR2(50) NOT NULL,
    LAST_NAME       VARCHAR2(50),
    EMAIL           VARCHAR2(100) UNIQUE,
    PHONE_NUMBER    VARCHAR2(15),
    CITY            VARCHAR2(50),
    STATE           VARCHAR2(50),
    COUNTRY         VARCHAR2(50),
    CREATED_DATE    DATE DEFAULT SYSDATE
);


INSERT INTO CUSTOMERS 
VALUES (101, 'Sameer', 'Ahmad', 'sameer@gmail.com', '9876543210', 
        'Delhi', 'Delhi', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (102, 'Amit', 'Sharma', 'amit@gmail.com', '9123456780', 
        'Mumbai', 'Maharashtra', 'India', SYSDATE);

COMMIT;



INSERT INTO CUSTOMERS 
VALUES (103, 'Priya', 'Mehta', 'priya@gmail.com', '9988776655', 
        'Pune', 'Maharashtra', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (104, 'Rahul', 'Verma', 'rahul@gmail.com', '9871234567', 
        'Bangalore', 'Karnataka', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (105, 'Neha', 'Singh', 'neha@gmail.com', '9765432109', 
        'Lucknow', 'Uttar Pradesh', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (106, 'Arjun', 'Kapoor', 'arjun@gmail.com', '9654321876', 
        'Chennai', 'Tamil Nadu', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (107, 'Sneha', 'Reddy', 'sneha@gmail.com', '9543218765', 
        'Hyderabad', 'Telangana', 'India', SYSDATE);

COMMIT;



INSERT INTO CUSTOMERS 
VALUES (108, 'Karan', 'Malhotra', 'karan@gmail.com', '9432109876', 
        'Jaipur', 'Rajasthan', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (109, 'Anjali', 'Desai', 'anjali@gmail.com', '9321098765', 
        'Ahmedabad', 'Gujarat', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (110, 'Vikram', 'Joshi', 'vikram@gmail.com', '9210987654', 
        'Kolkata', 'West Bengal', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (111, 'Pooja', 'Nair', 'pooja@gmail.com', '9109876543', 
        'Kochi', 'Kerala', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (112, 'Rohit', 'Yadav', 'rohit@gmail.com', '9098765432', 
        'Patna', 'Bihar', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (113, 'Divya', 'Iyer', 'divya@gmail.com', '8987654321', 
        'Coimbatore', 'Tamil Nadu', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (114, 'Siddharth', 'Gupta', 'sid@gmail.com', '8876543210', 
        'Noida', 'Uttar Pradesh', 'India', SYSDATE);

COMMIT;

SELECT * FROM CUSTOMERS;


INSERT INTO CUSTOMERS 
VALUES (115, 'Manish', 'Tiwari', 'manish@yahoo.com', '8765432190', 
        'Bhopal', 'Madhya Pradesh', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (116, 'Kavita', 'Saxena', 'kavita@rediffmail.com', '8654321987', 
        'Indore', 'Madhya Pradesh', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (117, 'Deepak', 'Arora', 'deepak@yahoo.in', '8543219876', 
        'Chandigarh', 'Chandigarh', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (118, 'Ritu', 'Bansal', 'ritu@rediffmail.com', '8432198765', 
        'Gurgaon', 'Haryana', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (119, 'Nitin', 'Agarwal', 'nitin@yahoo.com', '8321987654', 
        'Surat', 'Gujarat', 'India', SYSDATE);

INSERT INTO CUSTOMERS 
VALUES (120, 'Shalini', 'Pandey', 'shalini@rediffmail.com', '8219876543', 
        'Varanasi', 'Uttar Pradesh', 'India', SYSDATE);

COMMIT;



-------------------------------------


CREATE TABLE ORDERS (
    ORDER_ID        NUMBER(8) PRIMARY KEY,
    CUSTOMER_ID     NUMBER(6),
    ORDER_DATE      DATE DEFAULT SYSDATE,
    PRODUCT_NAME    VARCHAR2(100),
    QUANTITY        NUMBER(5),
    PRICE_PER_UNIT  NUMBER(10,2),
    TOTAL_AMOUNT    NUMBER(12,2),
    ORDER_STATUS    VARCHAR2(20),

    CONSTRAINT FK_CUSTOMER
    FOREIGN KEY (CUSTOMER_ID)
    REFERENCES CUSTOMERS(CUSTOMER_ID)
);



INSERT INTO ORDERS 
VALUES (1001, 101, SYSDATE, 'Laptop', 1, 60000, 60000, 'Delivered');

INSERT INTO ORDERS 
VALUES (1002, 115, SYSDATE, 'Mobile', 2, 15000, 30000, 'Shipped');

INSERT INTO ORDERS 
VALUES (1003, 118, SYSDATE, 'Headphones', 3, 2000, 6000, 'Pending');

INSERT INTO ORDERS 
VALUES (1004, 120, SYSDATE, 'Smart Watch', 1, 8000, 8000, 'Delivered');

INSERT INTO ORDERS VALUES (1005, 102, SYSDATE-10, 'Tablet', 1, 25000, 25000, 'Delivered');
INSERT INTO ORDERS VALUES (1006, 103, SYSDATE-8, 'Keyboard', 2, 1500, 3000, 'Delivered');
INSERT INTO ORDERS VALUES (1007, 104, SYSDATE-7, 'Mouse', 3, 800, 2400, 'Shipped');
INSERT INTO ORDERS VALUES (1008, 105, SYSDATE-6, 'Printer', 1, 12000, 12000, 'Pending');
INSERT INTO ORDERS VALUES (1009, 106, SYSDATE-5, 'Monitor', 2, 10000, 20000, 'Delivered');

INSERT INTO ORDERS VALUES (1010, 107, SYSDATE-4, 'External HDD', 1, 5000, 5000, 'Shipped');
INSERT INTO ORDERS VALUES (1011, 108, SYSDATE-3, 'Router', 2, 3000, 6000, 'Delivered');
INSERT INTO ORDERS VALUES (1012, 109, SYSDATE-2, 'Power Bank', 4, 1200, 4800, 'Pending');
INSERT INTO ORDERS VALUES (1013, 110, SYSDATE-12, 'Camera', 1, 45000, 45000, 'Delivered');
INSERT INTO ORDERS VALUES (1014, 111, SYSDATE-15, 'Speakers', 2, 3500, 7000, 'Shipped');

INSERT INTO ORDERS VALUES (1015, 112, SYSDATE-9, 'Projector', 1, 40000, 40000, 'Delivered');
INSERT INTO ORDERS VALUES (1016, 113, SYSDATE-11, 'SSD', 2, 7000, 14000, 'Delivered');
INSERT INTO ORDERS VALUES (1017, 114, SYSDATE-13, 'Graphics Card', 1, 55000, 55000, 'Pending');
INSERT INTO ORDERS VALUES (1018, 115, SYSDATE-14, 'Smart TV', 1, 65000, 65000, 'Delivered');
INSERT INTO ORDERS VALUES (1019, 116, SYSDATE-16, 'Gaming Console', 1, 38000, 38000, 'Shipped');

COMMIT;


---------------------------------------



CREATE TABLE RETURNS (
    RETURN_ID      NUMBER(8) PRIMARY KEY,
    ORDER_ID       NUMBER(8),
    CUSTOMER_ID    NUMBER(6),
    PRODUCT_NAME   VARCHAR2(100),
    RETURN_DATE    DATE DEFAULT SYSDATE,
    RETURN_REASON  VARCHAR2(200),
    REFUND_AMOUNT  NUMBER(12,2),

    CONSTRAINT FK_RETURN_ORDER
    FOREIGN KEY (ORDER_ID)
    REFERENCES ORDERS(ORDER_ID),

    CONSTRAINT FK_RETURN_CUSTOMER
    FOREIGN KEY (CUSTOMER_ID)
    REFERENCES CUSTOMERS(CUSTOMER_ID)
);
/



INSERT INTO RETURNS 
VALUES (5001, 1003, 118, 'Headphones', SYSDATE-1, 
        'Damaged product', 6000);

INSERT INTO RETURNS 
VALUES (5002, 1008, 105, 'Printer', SYSDATE-2, 
        'Not working properly', 12000);

INSERT INTO RETURNS 
VALUES (5003, 1017, 114, 'Graphics Card', SYSDATE-3, 
        'Wrong item delivered', 55000);

COMMIT;


INSERT INTO RETURNS 
VALUES (5004, 1005, 102, 'Tablet', SYSDATE-5,
        'Screen issue', 25000);

INSERT INTO RETURNS 
VALUES (5005, 1006, 103, 'Keyboard', SYSDATE-4,
        'Keys not working', 3000);

INSERT INTO RETURNS 
VALUES (5006, 1010, 107, 'External HDD', SYSDATE-6,
        'Storage failure', 5000);

INSERT INTO RETURNS 
VALUES (5007, 1012, 109, 'Power Bank', SYSDATE-3,
        'Battery problem', 4800);

INSERT INTO RETURNS 
VALUES (5008, 1014, 111, 'Speakers', SYSDATE-7,
        'Sound distortion', 7000);

INSERT INTO RETURNS 
VALUES (5009, 1016, 113, 'SSD', SYSDATE-8,
        'Not detected', 14000);

INSERT INTO RETURNS 
VALUES (5010, 1018, 115, 'Smart TV', SYSDATE-2,
        'Display issue', 65000);

INSERT INTO RETURNS 
VALUES (5011, 1019, 116, 'Gaming Console', SYSDATE-9,
        'Controller defect', 38000);

COMMIT;




INSERT INTO RETURNS 
VALUES (5012, 1007, 104, 'Mouse', SYSDATE-3,
        'Scroll not working', 2400);

INSERT INTO RETURNS 
VALUES (5013, 1009, 106, 'Monitor', SYSDATE-4,
        'Dead pixels', 20000);

INSERT INTO RETURNS 
VALUES (5014, 1011, 108, 'Router', SYSDATE-6,
        'Connectivity issue', 6000);

INSERT INTO RETURNS 
VALUES (5015, 1013, 110, 'Camera', SYSDATE-10,
        'Lens problem', 45000);

INSERT INTO RETURNS 
VALUES (5016, 1015, 112, 'Projector', SYSDATE-7,
        'Heating issue', 40000);

INSERT INTO RETURNS 
VALUES (5017, 1002, 115, 'Mobile', SYSDATE-5,
        'Battery drain', 30000);

INSERT INTO RETURNS 
VALUES (5018, 1004, 120, 'Smart Watch', SYSDATE-2,
        'Strap broken', 8000);

INSERT INTO RETURNS 
VALUES (5019, 1001, 101, 'Laptop', SYSDATE-12,
        'Keyboard issue', 60000);

COMMIT;