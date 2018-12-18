# Yam Database

> The database for the mobile application, Yam.

<!--
[![NPM Version][npm-image]][npm-url]
[![Build Status][travis-image]][travis-url]
[![Downloads Stats][npm-downloads]][npm-url]
-->

This is the repo for the database skeleton that backs the mobile application Yam.

<!--
![](header.png)
-->

## Installation

First and foremost, **you must have Docker installed**

_These instructions should be the same for OS X & Linux & Windows_

```sh
docker run -d -p 5432:5432 --name postgis-db -e POSTGRES_PASSWORD=root -d mdillon/postgis

docker exec -it postgis-db sh -c 'exec psql -U postgres'
```

Note: you will be prompted for the postgres password we set, which is **root**

From within the psql shell, run these commands to create our user and database

```sql
CREATE USER yamuser WITH password 'secret-password';
CREATE DATABASE yamdb;
ALTER DATABASE yamdb OWNER TO yamuser;
\q
```

Now lets run the setup files to create the schema and functions

```sh
docker cp sql/. postgis-db:/setup-files/
docker cp setup.sql postgis-db:/setup-files/

docker exec -it postgis-db sh -c "exec psql -U yamuser -d yamdb -a -f setup-files/setup.sql"
```

To verify that the tables were created, you may check with psql

```sh
docker exec -it postgis-db sh -c "psql -d yamdb -U yamuser"
```

Then run this command in the db shell to see all the tables in our schema

```sh
\dt yamschema.*
```

_`\q` to quit_

If there are tables at this point, congrats, you are ready to use the db

If there are no tables, please kill/restart the container and try again

## Making Changes to the SQL

This command will **ERASE** everything thats in the Database

```sh
docker cp sql/. postgis-db:/setup-files/
docker cp setup.sql postgis-db:/setup-files/
docker exec -it postgis-db sh -c "exec psql -U yamuser -d yamdb -a -f setup-files/setup.sql"
```

## Release History

- 0.0.1
  - Work in progress

<!--
## Contributing

1. Fork it (<https://github.com/yourname/yourproject/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request
-->

<!-- Markdown link & img dfn's -->

[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[wiki]: https://github.com/yourname/yourproject/wiki
