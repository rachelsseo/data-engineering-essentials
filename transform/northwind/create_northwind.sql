--
-- DuckDB database schema
--

DROP TABLE IF EXISTS customer_customer_demo;
DROP TABLE IF EXISTS customer_demographics;
DROP TABLE IF EXISTS employee_territories;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS shippers;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS territories;
DROP TABLE IF EXISTS us_states;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS region;
DROP TABLE IF EXISTS employees;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    category_id INTEGER NOT NULL PRIMARY KEY,
    category_name VARCHAR(15) NOT NULL,
    description TEXT,
    picture BLOB
);


--
-- Name: customer_demographics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customer_demographics (
    customer_type_id CHAR NOT NULL PRIMARY KEY,
    customer_desc TEXT
);


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers (
    customer_id CHAR NOT NULL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24)
);

--
-- Name: customer_customer_demo; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customer_customer_demo (
    customer_id CHAR NOT NULL,
    customer_type_id CHAR NOT NULL,
    PRIMARY KEY (customer_id, customer_type_id)
);

--
-- Name: employees; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employees (
    employee_id INTEGER NOT NULL PRIMARY KEY,
    last_name VARCHAR(20) NOT NULL,
    first_name VARCHAR(10) NOT NULL,
    title VARCHAR(30),
    title_of_courtesy VARCHAR(25),
    birth_date DATE,
    hire_date DATE,
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    home_phone VARCHAR(24),
    extension VARCHAR(4),
    photo BLOB,
    notes TEXT,
    reports_to INTEGER,
    photo_path VARCHAR(255)
);


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suppliers (
    supplier_id INTEGER NOT NULL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    contact_name VARCHAR(30),
    contact_title VARCHAR(30),
    address VARCHAR(60),
    city VARCHAR(15),
    region VARCHAR(15),
    postal_code VARCHAR(10),
    country VARCHAR(15),
    phone VARCHAR(24),
    fax VARCHAR(24),
    homepage TEXT
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    product_id INTEGER NOT NULL PRIMARY KEY,
    product_name VARCHAR(40) NOT NULL,
    supplier_id INTEGER,
    category_id INTEGER,
    quantity_per_unit VARCHAR(20),
    unit_price DOUBLE,
    units_in_stock INTEGER,
    units_on_order INTEGER,
    reorder_level INTEGER,
    discontinued INTEGER NOT NULL
);


--
-- Name: region; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE region (
    region_id INTEGER NOT NULL PRIMARY KEY,
    region_description CHAR NOT NULL
);


--
-- Name: shippers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shippers (
    shipper_id INTEGER NOT NULL PRIMARY KEY,
    company_name VARCHAR(40) NOT NULL,
    phone VARCHAR(24)
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE orders (
    order_id INTEGER NOT NULL PRIMARY KEY,
    customer_id CHAR,
    employee_id INTEGER,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    ship_via INTEGER,
    freight DOUBLE,
    ship_name VARCHAR(40),
    ship_address VARCHAR(60),
    ship_city VARCHAR(15),
    ship_region VARCHAR(15),
    ship_postal_code VARCHAR(10),
    ship_country VARCHAR(15)
);


--
-- Name: territories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE territories (
    territory_id VARCHAR(20) NOT NULL PRIMARY KEY,
    territory_description CHAR NOT NULL,
    region_id INTEGER NOT NULL
);


--
-- Name: employee_territories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE employee_territories (
    employee_id INTEGER NOT NULL,
    territory_id VARCHAR(20) NOT NULL,
    PRIMARY KEY (employee_id, territory_id)
);


--
-- Name: order_details; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE order_details (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    unit_price DOUBLE NOT NULL,
    quantity INTEGER NOT NULL,
    discount DOUBLE NOT NULL,
    PRIMARY KEY (order_id, product_id)
);


--
-- Name: us_states; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE us_states (
    state_id INTEGER NOT NULL PRIMARY KEY,
    state_name VARCHAR(100),
    state_abbr VARCHAR(2),
    state_region VARCHAR(50)
);