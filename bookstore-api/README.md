# Nest.js + Prisma

**今後の起動コマンド:**

```sh
# DB起動
docker compose up -d

# テーブル作成（初回のみ）
docker exec -i ps psql -U test test < bookstore-api/prisma/create-tables.sql

# Seedデータ投入
docker exec -i ps psql -U test test < bookstore-api/prisma/seed.sql

# Prisma Studio
cd bookstore-api && npx prisma studio
```

Gitの差分が多いので、nest.jsディレクトリ内で、`.gitignore`を設定する。

```
# Dependencies
node_modules/

# Build output
dist/

# Environment
.env

# Prisma
/generated/prisma
```

VSCodeを使用している場合は、Windowをリロードする。

cmd + shift + p -> Reload Windowと検索してそれらしきものを実行する。