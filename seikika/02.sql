-- 第2正規化: 書籍テーブル（Books）
-- 注: 書籍名がキーだと重複の可能性があるため、実務ではISBNなどを使いますが、ここでは簡略化のためタイトルを一時的なIDとみなします
CREATE TABLE books_2nf (
    book_title VARCHAR(100) PRIMARY KEY,
    book_price INT,
    publisher_name VARCHAR(50),
    publisher_address VARCHAR(100)
);

-- 第2正規化: 注文詳細テーブル（OrderDetails）
-- 注文と書籍を結びつける中間テーブル（数量は「どの注文でどの本を何冊」なのでここに残る）
CREATE TABLE order_details_2nf (
    order_id VARCHAR(10),
    book_title VARCHAR(100),
    quantity INT,
    PRIMARY KEY (order_id, book_title),
    FOREIGN KEY (order_id) REFERENCES orders_2nf(order_id),
    FOREIGN KEY (book_title) REFERENCES books_2nf(book_title)
);

-- 1. まず子テーブルを空にする（外部キー制約があるため先に行う）
DELETE FROM order_details_2nf;

-- 2. 次に親テーブルを空にする
DELETE FROM books_2nf;
DELETE FROM orders_2nf;

-- 3. 親テーブル(Books)にデータを登録
INSERT INTO books_2nf (book_title, book_price, publisher_name, publisher_address)
SELECT DISTINCT book_title, book_price, publisher_name, publisher_address
FROM raw_orders;

-- 4. 親テーブル(Orders)にデータを登録
INSERT INTO orders_2nf (order_id, order_date, customer_name, customer_email)
SELECT DISTINCT order_id, order_date, customer_name, customer_email
FROM raw_orders;

-- 5. 最後に子テーブル(OrderDetails)にデータを登録
INSERT INTO order_details_2nf (order_id, book_title, quantity)
SELECT order_id, book_title, quantity
FROM raw_orders;

-- 確認: 書籍テーブル
SELECT * FROM books_2nf;
-- 確認: 注文テーブル
SELECT * FROM orders_2nf;
-- 確認: 注文詳細テーブル
SELECT * FROM order_details_2nf;    
-- 不要になった元の非正規形テーブルを削除