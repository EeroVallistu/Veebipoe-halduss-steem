-- Kategooriad
CREATE TABLE categories (
    category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'INT UNSIGNED valiti, kuna see pakub piisavalt suurt numbrite vahemikku (0 kuni 4,294,967,295) ID-de jaoks. TINYINT oleks liiga väike, BIGINT liiga suur.',
    name VARCHAR(255) NOT NULL UNIQUE COMMENT 'VARCHAR(255) valiti, kuna kategooria nimed on erineva pikkusega. CHAR oleks raiskav, TEXT liiga suur.'
);

-- Tooted
CREATE TABLE products (
    product_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'INT UNSIGNED valiti, kuna see sobib hästi suurele hulgale toodetele. BIGINT oleks liiga suur, SMALLINT liiga väike.',
    name VARCHAR(255) NOT NULL COMMENT 'VARCHAR(255) valiti, kuna tootenimed on erineva pikkusega. CHAR oleks raiskav, TEXT liiga suur.',
    description TEXT COMMENT 'TEXT valiti, kuna tootekirjeldused võivad olla pikad. VARCHAR oleks piiratud, MEDIUMTEXT liiga suur.',
    price DECIMAL(10,2) NOT NULL COMMENT 'DECIMAL(10,2) valiti, kuna see tagab täpse kümnendkoha kahe kohaga. FLOAT või DOUBLE oleks ebatäpne rahasummade jaoks.',
    category_id INT UNSIGNED NOT NULL COMMENT 'INT UNSIGNED valiti, kuna see peab vastama categories.category_id tüübile. TINYINT oleks liiga väike.',
    stock INT NOT NULL DEFAULT 0 COMMENT 'INT valiti, kuna laoseis võib olla suur. TINYINT oleks liiga väike, BIGINT liiga suur.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'TIMESTAMP valiti, kuna see on ajatsoonidega ühilduv ja salvestab aja UTC formaadis.',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'TIMESTAMP valiti, kuna see on ajatsoonidega ühilduv ja salvestab aja UTC formaadis. Automaatselt uuendab aega muudatuste korral.',
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Kliendid
CREATE TABLE customers (
    customer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'INT UNSIGNED valiti, kuna see sobib hästi suurele hulgale klientidele. BIGINT oleks liiga suur, SMALLINT liiga väike.',
    first_name VARCHAR(255) NOT NULL COMMENT 'VARCHAR(255) valiti, kuna eesnimed on erineva pikkusega. CHAR oleks raiskav, TEXT liiga suur.',
    last_name VARCHAR(255) NOT NULL COMMENT 'VARCHAR(255) valiti, kuna perekonnanimed on erineva pikkusega. CHAR oleks raiskav, TEXT liiga suur.',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT 'VARCHAR(255) valiti, kuna e-posti aadressid on erineva pikkusega. CHAR oleks raiskav, TEXT liiga suur.',
    phone VARCHAR(20) COMMENT 'VARCHAR(20) valiti, kuna telefoninumbrid on erineva pikkusega. CHAR oleks raiskav, TEXT liiga suur.',
    address TEXT NOT NULL COMMENT 'TEXT valiti, kuna aadressid võivad olla pikad. VARCHAR oleks piiratud, MEDIUMTEXT liiga suur.',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'TIMESTAMP valiti, kuna see on ajatsoonidega ühilduv ja salvestab aja UTC formaadis.'
);

-- Tellimused
CREATE TABLE orders (
    order_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'INT UNSIGNED valiti, kuna see sobib hästi suurele hulgale tellimustele. BIGINT oleks liiga suur, SMALLINT liiga väike.',
    customer_id INT UNSIGNED NOT NULL COMMENT 'INT UNSIGNED valiti, kuna see peab vastama customers.customer_id tüübile. TINYINT oleks liiga väike.',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'TIMESTAMP valiti, kuna see on ajatsoonidega ühilduv ja salvestab aja UTC formaadis.',
    total_amount DECIMAL(10,2) NOT NULL COMMENT 'DECIMAL(10,2) valiti, kuna see tagab täpse kümnendkoha kahe kohaga. FLOAT või DOUBLE oleks ebatäpne rahasummade jaoks.',
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending' COMMENT 'ENUM valiti, kuna olekud on fikseeritud valikud. VARCHAR oleks vähem efektiivne.',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Tellimuse üksused (liittabel)
CREATE TABLE order_items (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'INT UNSIGNED valiti, kuna see sobib hästi suurele hulgale tellimuse üksustele. BIGINT oleks liiga suur, SMALLINT liiga väike.',
    order_id INT UNSIGNED NOT NULL COMMENT 'INT UNSIGNED valiti, kuna see peab vastama orders.order_id tüübile. TINYINT oleks liiga väike.',
    product_id INT UNSIGNED NOT NULL COMMENT 'INT UNSIGNED valiti, kuna see peab vastama products.product_id tüübile. TINYINT oleks liiga väike.',
    quantity INT NOT NULL COMMENT 'INT valiti, kuna kogus võib olla suur. TINYINT oleks liiga väike, BIGINT liiga suur.',
    price DECIMAL(10,2) NOT NULL COMMENT 'DECIMAL(10,2) valiti, kuna see tagab täpse kümnendkoha kahe kohaga. FLOAT või DOUBLE oleks ebatäpne rahasummade jaoks.',
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Arved
CREATE TABLE invoices (
    invoice_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'INT UNSIGNED valiti, kuna see sobib hästi suurele hulgale arvetele. BIGINT oleks liiga suur, SMALLINT liiga väike.',
    order_id INT UNSIGNED NOT NULL UNIQUE COMMENT 'INT UNSIGNED valiti, kuna see peab vastama orders.order_id tüübile. TINYINT oleks liiga väike.',
    invoice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'TIMESTAMP valiti, kuna see on ajatsoonidega ühilduv ja salvestab aja UTC formaadis.',
    due_date TIMESTAMP COMMENT 'TIMESTAMP valiti, kuna see on ajatsoonidega ühilduv ja salvestab aja UTC formaadis.',
    total_amount DECIMAL(10,2) NOT NULL COMMENT 'DECIMAL(10,2) valiti, kuna see tagab täpse kümnendkoha kahe kohaga. FLOAT või DOUBLE oleks ebatäpne rahasummade jaoks.',
    status ENUM('unpaid', 'paid', 'overdue') DEFAULT 'unpaid' COMMENT 'ENUM valiti, kuna olekud on fikseeritud valikud. VARCHAR oleks vähem efektiivne.',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Saadetised
CREATE TABLE shipments (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT 'INT UNSIGNED valiti, kuna see sobib hästi suurele hulgale saadetistele. BIGINT oleks liiga suur, SMALLINT liiga väike.',
    order_id INT UNSIGNED NOT NULL COMMENT 'INT UNSIGNED valiti, kuna see peab vastama orders.order_id tüübile. TINYINT oleks liiga väike.',
    shipment_date TIMESTAMP COMMENT 'TIMESTAMP valiti, kuna see on ajatsoonidega ühilduv ja salvestab aja UTC formaadis.',
    tracking_number VARCHAR(255) COMMENT 'VARCHAR(255) valiti, kuna jälgimisnumbrid on erineva pikkusega. CHAR oleks raiskav, TEXT liiga suur.',
    carrier VARCHAR(255) COMMENT 'VARCHAR(255) valiti, kuna vedaja nimed on erineva pikkusega. CHAR oleks raiskav, TEXT liiga suur.',
    status ENUM('preparing', 'shipped', 'delivered') DEFAULT 'preparing' COMMENT 'ENUM valiti, kuna olekud on fikseeritud valikud. VARCHAR oleks vähem efektiivne.',
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
