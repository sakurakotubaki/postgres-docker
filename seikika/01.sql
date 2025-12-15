-- 非正規形（第1正規形相当）のテーブル作成
CREATE TABLE raw_orders (
    order_id VARCHAR(10),        -- 注文ID
    order_date DATE,             -- 注文日
    customer_name VARCHAR(50),   -- 顧客名
    customer_email VARCHAR(50),  -- 顧客Email
    book_title VARCHAR(100),     -- 書籍タイトル
    book_price INT,              -- 書籍単価
    quantity INT,                -- 注文数
    publisher_name VARCHAR(50),  -- 出版社名
    publisher_address VARCHAR(100) -- 出版社住所
);

-- サンプルデータの投入
INSERT INTO raw_orders VALUES
('ORD001', '2023-10-01', '山田太郎', 'yamada@example.com', 'SQL入門', 2500, 1, '技術評論社', '東京都新宿区'),
('ORD001', '2023-10-01', '山田太郎', 'yamada@example.com', 'Webデザイン基礎', 3000, 2, 'デザイン出版', '東京都渋谷区'),
('ORD002', '2023-10-02', '鈴木花子', 'suzuki@example.com', 'SQL入門', 2500, 1, '技術評論社', '東京都新宿区'),
('ORD003', '2023-10-03', '佐藤次郎', 'sato@example.com', 'Python実践', 3500, 1, '技術評論社', '東京都新宿区');

-- 確認
SELECT * FROM "raw_orders";