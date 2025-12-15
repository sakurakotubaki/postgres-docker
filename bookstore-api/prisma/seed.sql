-- 第3正規化テーブルのシードデータ
-- 既存データをクリア（外部キー制約の順序に注意）
TRUNCATE TABLE order_details_3nf CASCADE;
TRUNCATE TABLE orders_3nf CASCADE;
TRUNCATE TABLE books_3nf CASCADE;
TRUNCATE TABLE publishers_3nf CASCADE;

-- 出版社テーブル (publishers_3nf)
INSERT INTO publishers_3nf (publisher_name, publisher_address) VALUES
('技術評論社', '東京都新宿区'),
('デザイン出版', '東京都渋谷区'),
('オライリー・ジャパン', '東京都千代田区'),
('翔泳社', '東京都新宿区市谷'),
('インプレス', '東京都千代田区神田');

-- 書籍テーブル (books_3nf)
INSERT INTO books_3nf (book_title, book_price, publisher_id) VALUES
('SQL入門', 2500, 1),
('Webデザイン基礎', 3000, 2),
('Python実践', 3500, 1),
('JavaScript入門', 2800, 3),
('React実践ガイド', 3200, 4),
('データベース設計入門', 2900, 1),
('TypeScript徹底解説', 3400, 5);

-- 注文テーブル (orders_3nf)
INSERT INTO orders_3nf (order_id, order_date, customer_name, customer_email) VALUES
('ORD001', '2023-10-01', '山田太郎', 'yamada@example.com'),
('ORD002', '2023-10-02', '鈴木花子', 'suzuki@example.com'),
('ORD003', '2023-10-03', '佐藤次郎', 'sato@example.com'),
('ORD004', '2023-10-05', '田中美咲', 'tanaka@example.com'),
('ORD005', '2023-10-10', '高橋健一', 'takahashi@example.com');

-- 注文詳細テーブル (order_details_3nf)
INSERT INTO order_details_3nf (order_id, book_title, quantity) VALUES
('ORD001', 'SQL入門', 1),
('ORD001', 'Webデザイン基礎', 2),
('ORD002', 'SQL入門', 1),
('ORD003', 'Python実践', 1),
('ORD004', 'JavaScript入門', 2),
('ORD004', 'React実践ガイド', 1),
('ORD005', 'データベース設計入門', 1),
('ORD005', 'TypeScript徹底解説', 1),
('ORD005', 'Python実践', 1);
