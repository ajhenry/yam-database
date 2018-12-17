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
*These instructions should be the same for OS X & Linux & Windows*

```sh
docker run -d -p 5432:5432 --name postgis-db -e POSTGRES_PASSWORD=root -d mdillon/postgis

docker exec -it postgis-db sh -c 'exec psql -U postgres'
```
Note: you will be prompted for the postgres password we set, which is **root**


From within the psql shell, run these commands to create our user and database
```sql
CREATE USER yamuser WITH password 'secret-password';
CREATE DATABASE yamdb;
GRANT ALL PRIVILEGES ON DATABASE "yamdb" to yamuser;
ALTER DATABASE yamdb SET search_path TO yamschema;
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
*`\q` to quit*

If there are tables at this point, congrats, you are ready to use the db

If there are no tables, please kill/restart the container and try again

## Usage example

A few motivating and useful examples of how your product can be used. Spice this up with code blocks and potentially more screenshots.

_For more examples and usage, please refer to the [Wiki][wiki]._

## Development setup

Describe how to install all development dependencies and how to run an automated test-suite of some kind. Potentially do this for multiple platforms.

```sh
make install
npm test
```

## Release History

* 0.2.1
    * CHANGE: Update docs (module code remains unchanged)
* 0.2.0
    * CHANGE: Remove `setDefaultXYZ()`
    * ADD: Add `init()`
* 0.1.1
    * FIX: Crash when calling `baz()` (Thanks @GenerousContributorName!)
* 0.1.0
    * The first proper release
    * CHANGE: Rename `foo()` to `bar()`
* 0.0.1
    * Work in progress

## Meta

Your Name – [@YourTwitter](https://twitter.com/dbader_org) – YourEmail@example.com

Distributed under the XYZ license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

## Contributing

1. Fork it (<https://github.com/yourname/yourproject/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

<!-- Markdown link & img dfn's -->
[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[wiki]: https://github.com/yourname/yourproject/wiki
