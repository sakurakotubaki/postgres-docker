# PostgreSQLによるデータベース正規化ガイド 
(第1正規化〜第3正規化)このドキュメントでは、書籍の注文データを例に、非正規形のテーブルを作成し、それを第3正規化まで段階的に分割していくプロセスを解説します。0. シナリオと初期状態シナリオ: 書店が注文記録をExcelや単一のCSVファイルのように1つの表で管理しています。問題点: データが重複しており、データの整合性を保つのが難しい（例：出版社の住所が変わった場合、全ての行を修正する必要がある）。1. 非正規形（Unnormalized Form） / 第1正規形（1NF）の準備まずは、全てのデータが1つのテーブルに入っている状態（フラットテーブル）を作成します。リレーショナルデータベースではセルに複数の値を入れることができないため、この段階で「1セル1値（原子性）」を満たしているものとし、実質的に第1正規形の状態にある巨大なテーブルを作成します。ステップ 1: 巨大なテーブルの作成とデータ投入-- 既存のテーブルがあれば削除
DROP TABLE IF EXISTS raw_orders;

```sql
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
SELECT * FROM raw_orders;
```

この状態の問題点:冗長性: 「SQL入門」の情報（価格、出版社）が何度も登場している。更新時異状: 「技術評論社」の住所が変わった場合、複数の行を更新しないと不整合が起きる。2. 第2正規形（2NF）への変換定義: 第1正規形であり、かつ「主キーの一部にのみ依存する項目（部分関数従属）」を別テーブルに分離した状態。現在の主キーは (order_id, book_title) の複合キーとみなせます。注文に関する情報 (customer_name, date 等) は order_id だけで決まります。書籍に関する情報 (price, publisher 等) は book_title だけで決まります。これらを分離します。ステップ 2: テーブルの分割クエリ-- 第2正規化: 注文テーブル（Orders）
CREATE TABLE orders_2nf (
    order_id VARCHAR(10) PRIMARY KEY,
    order_date DATE,
    customer_name VARCHAR(50),
    customer_email VARCHAR(50)
);

```sql
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
```

この状態の問題点:books_2nf テーブルにおいて、publisher_address（出版社住所）は book_title（書籍）に直接依存しているというより、publisher_name（出版社）に依存しています。これを「推移的関数従属」といい、まだ冗長性が残っています。3. 第3正規形（3NF）への変換定義: 第2正規形であり、かつ「主キー以外の項目に依存する項目（推移的関数従属）」を別テーブルに分離した状態。books_2nf テーブルから、出版社情報を切り出します。ステップ 3: さらにテーブルを分割するクエリ-- 第3正規化: 出版社テーブル（Publishers）の新規作成
CREATE TABLE publishers_3nf (
    publisher_id SERIAL PRIMARY KEY, -- 管理しやすいようにIDを付与
    publisher_name VARCHAR(50) UNIQUE,
    publisher_address VARCHAR(100)
);

```sql
CREATE TABLE publishers_3nf (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name VARCHAR(50) UNIQUE,
    publisher_address VARCHAR(100)
);

-- 第3正規化: 書籍テーブル（Books）の再構築
-- 出版社名や住所の代わりに publisher_id を持ちます
CREATE TABLE books_3nf (
    book_title VARCHAR(100) PRIMARY KEY,
    book_price INT,
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES publishers_3nf(publisher_id)
);

-- 注文テーブルと詳細テーブルは第2正規化のものをそのまま使用（変更なし）
-- 説明のためテーブル名だけ _3nf にしてコピーします
CREATE TABLE orders_3nf AS SELECT * FROM orders_2nf;
ALTER TABLE orders_3nf ADD PRIMARY KEY (order_id); -- 制約の再適用

CREATE TABLE order_details_3nf (
    order_id VARCHAR(10),
    book_title VARCHAR(100),
    quantity INT,
    PRIMARY KEY (order_id, book_title),
    FOREIGN KEY (order_id) REFERENCES orders_3nf(order_id),
    FOREIGN KEY (book_title) REFERENCES books_3nf(book_title)
);

-- データ移行: Publishers
INSERT INTO publishers_3nf (publisher_name, publisher_address)
SELECT DISTINCT publisher_name, publisher_address
FROM books_2nf;

-- データ移行: Books (出版社IDを紐付けて挿入)
INSERT INTO books_3nf (book_title, book_price, publisher_id)
SELECT 
    b2.book_title, 
    b2.book_price, 
    p3.publisher_id
FROM books_2nf b2
JOIN publishers_3nf p3 ON b2.publisher_name = p3.publisher_name;

-- データ移行: OrderDetails (2NFからそのままコピー)
INSERT INTO order_details_3nf SELECT * FROM order_details_2nf;
4. 最終確認第3正規化が完了したことで、データ構造は以下のようになりました。orders_3nf: 注文自体の情報（誰が、いつ）publishers_3nf: 出版社のマスタ情報（住所など）books_3nf: 書籍のマスタ情報（価格、どの出版社か）order_details_3nf: 注文明細（どの注文で、どの本が、いくつ）元のデータを復元するクエリ（検証）正規化しても、JOINを使えば元の表と同じ情報を取得できるはずです。SELECT 
    o.order_id,
    o.order_date,
    o.customer_name,
    b.book_title,
    b.book_price,
    od.quantity,
    p.publisher_name,
    p.publisher_address
FROM orders_3nf o
JOIN order_details_3nf od ON o.order_id = od.order_id
JOIN books_3nf b ON od.book_title = b.book_title
JOIN publishers_3nf p ON b.publisher_id = p.publisher_id
ORDER BY o.order_id;
```

以下のエラーが発生し時は、ターミナルで実行する。

Query 1 ERROR at Line 1: : ERROR:  relation "orders_3nf" does not exist

```sql
CREATE TABLE orders_3nf AS SELECT * FROM orders_2nf;
ALTER TABLE orders_3nf ADD PRIMARY KEY (order_id);
```

```sql
CREATE TABLE order_details_3nf (
    order_id VARCHAR(10),
    book_title VARCHAR(100),
    quantity INT,
    PRIMARY KEY (order_id, book_title),
    FOREIGN KEY (order_id) REFERENCES orders_3nf(order_id),
    FOREIGN KEY (book_title) REFERENCES books_3nf(book_title)
);
```

```sql
-- Publishersへデータ移行
INSERT INTO publishers_3nf (publisher_name, publisher_address)
SELECT DISTINCT publisher_name, publisher_address
FROM books_2nf;

-- Booksへデータ移行
INSERT INTO books_3nf (book_title, book_price, publisher_id)
SELECT 
    b2.book_title, 
    b2.book_price, 
    p3.publisher_id
FROM books_2nf b2
JOIN publishers_3nf p3 ON b2.publisher_name = p3.publisher_name;

-- OrderDetailsへデータ移行
INSERT INTO order_details_3nf SELECT * FROM order_details_2nf;
```

分割したテーブルを結合するクエリ

```sql
SELECT 
    o.order_id,
    o.order_date,
    o.customer_name,
    o.customer_email,
    b.book_title,
    b.book_price,
    od.quantity,
    p.publisher_name,
    p.publisher_address
FROM orders_3nf o
JOIN order_details_3nf od ON o.order_id = od.order_id
JOIN books_3nf b ON od.book_title = b.book_title
JOIN publishers_3nf p ON b.publisher_id = p.publisher_id
ORDER BY o.order_id;
```