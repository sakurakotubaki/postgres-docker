# Docker PostgreSQL

**portの解放**

```sh
docker run -d --name ps \
-p 5432:5432 \
-e POSTGRES_DB=test \
-e POSTGRES_USER=test \
-e POSTGRES_PASSWORD=test \
postgres:15
```



Run PostgreSQL Server

```sh
docker exec -it ps psql -U test test
```

**create table**

```sql
CREATE TABLE person (
    name varchar(50),
    birthday date
);
```

```sql
INSERT INTO person(name, birthday) VALUES ('田中太郎', '1980-01-01');
INSERT INTO person(name, birthday) VALUES ('山田花子', '1995-05-15');
INSERT INTO person(name, birthday) VALUES ('佐藤秀明', '2000-12-25');
INSERT INTO person(name, birthday) VALUES ('坂本竜馬', '1836-01-03');
```

get all data

```sql
SELECT * FROM person;
```

drop table
```sql
DROP TABLE person;
```