-- 第3正規化テーブル作成

-- 出版社テーブル
CREATE TABLE IF NOT EXISTS publishers_3nf (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name VARCHAR(50) UNIQUE,
    publisher_address VARCHAR(100)
);

-- 書籍テーブル
CREATE TABLE IF NOT EXISTS books_3nf (
    book_title VARCHAR(100) PRIMARY KEY,
    book_price INT,
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publishers_3nf(publisher_id)
);

-- 注文テーブル
CREATE TABLE IF NOT EXISTS orders_3nf (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(50),
    customer_email VARCHAR(50)
);

-- 注文詳細テーブル
CREATE TABLE IF NOT EXISTS order_details_3nf (
    order_id VARCHAR(10),
    book_title VARCHAR(100),
    quantity INT,
    PRIMARY KEY (order_id, book_title),
    FOREIGN KEY (order_id) REFERENCES orders_3nf(order_id),
    FOREIGN KEY (book_title) REFERENCES books_3nf(book_title)
);
