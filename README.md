# README

API CRUD applicantion for stocks with bearer association respecting JSON::API specification (https://jsonapi.org/)

Ruby version 3.1.2 (specified in .ruby-version)

System dependency is MySql database (requires installation). Default user is used for development purposes (without authorization)

Database is created through built-in rails method (rails db:create)

Migrating database - rails db:migrate

Test suite is run though RSpec suite

## Task description:

### Please create 2 models with at least the following attributes:
* Stock (name: string - must be unique)
* Bearer (name: string - must be unique)(can own many stocks)

### Please create some JSON API endpoints:
1. Create a _stock_ with a referenced _bearer_.
2. Update a _stock_.
3. The _bearer_ cannot be updated via _stock_ update endpoint. If you need to change the _bearer_, a new object needs to be created. If _bearer_ exists already, it must be re-used and connected to the _stock_.
4. List all _stocks_ with _bearer_ information.
5. Soft-delete a _stock_ so it doesn't appear on the API.

**NOTE:** Error responses should be detailed enough to see what exactly missied or wrong.