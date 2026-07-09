CREATE DATABASE IF NOT EXISTS inventory_db;

USE inventory_db;

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    minimum_stock_level INT NOT NULL DEFAULT 5,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

INSERT INTO categories (id, name, description) VALUES
(1, 'samsung', 'Good Phone'),
(2, 'Tecno', 'China factory'),
(3, 'Itel', 'china');

INSERT INTO products (id, product_code, name, description, image_url, price, stock_quantity, minimum_stock_level, category_id) VALUES
(1, 'SKu-24325', 'iphone 17 pro max', '128gb', 'https://sm.mashable.com/mashable_sea/review/a/apple-ipho/apple-iphone-17-pro-max-review-the-mighty-workhorse-we-neede_4xg6.jpg', 800000.00, 40, 3, 1),
(2, 'SKu-243267', 'Samsung A22', 'Tres bon telephone', 'https://etimg.etb2bimg.com/photo/84671862.cms', 90000.00, 9, 5, 1),
(3, 'SKu-24325-COPY-1749245767787', 'iphone 12 pro max (Copy)', '64gb', 'https://www.cnet.com/a/img/resize/887997d313cda859afd73f96615c96a51338a5ca/hub/2020/10/18/bdb7ea97-cb99-48d8-a69c-38d26109f33b/05-iphone-12-pro-2020.jpg?auto=webp&fit=crop&height=900&width=1200', 800000.00, 27, 3, 1),
(5, 'SKu-24326744', 'Tecno Comon 20', 'Latest CAMON 20 series from TECNO: 6.67-inch FHD+ AMOLED display, MediaTek Dimensity 8050 processor, 8GB RAM, 64MP RGBW OIS main camera, 5000mAh battery with 33W fast charging. Features Magic Skin back material and runs Android 13 with HiOS 13.', 'https://images.fonearena.com/blog/wp-content/uploads/2023/05/TECNO-CAMON-20-Series.jpg', 90000.00, 28, 10, 2),
(7, 'Sk-45u578', 'Xperia 5 IV 5G 8/256GB Refurbished', 'Sony Xperia 1 VIII - 6.5\" FHD+ HDR OLED 120Hz, Triple lens camera, 2-day battery, 3.5mm Audio, Dual SIM', 'https://www.triveniworld.com/cdn/shop/products/sony-xperia-5-iv-5g-8256gb-refurbished-triveni-world-2.jpg?v=1736272682', 50000.00, 10, 2, 2);

CREATE TABLE sales (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    product_code VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    sold_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id)
);
