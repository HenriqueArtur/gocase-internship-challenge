#  Gocase - Backend Challenge (REST API)
*This API was developed as a Backend Challenge to Gocase's recruitment process for internship.*

### On this API it's possible to:
* Add __Orders__ to database;
* Get the *'status'* of an __Order__ pass *'reference'* or *'client name*';
* List the __Orders__ of a *'Purchase Channel'* restricting to a single *'status'*;
* Create a __Batch__ choosing *'Purchase Channel'*;
* Change *'status'* of __Orders__ in a __Batch__.

## Dependencies
* Ruby: 2.4.4
* Rails: 5.2.4.1
* Postgres 12.1

## Gems
* [tty-spinner](https://github.com/piotrmurach/tty-spinner)
* [pry-rails](https://github.com/rweng/pry-rails)
* [faker](https://github.com/faker-ruby/faker)
* [rspec](https://github.com/rspec/rspec-rails)
* [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)

## Configuration
1. Clone the project:
```$ git clone https://github.com/PassaroRoxo/gocase-internship-challenge.git```

2. Ajust in ```config/database.yml``` *username:* and *password:*.

3. Run ```rails dev:setup``` on console. This task runs ```bundle install```, ```rails db:create```, ```rails db:migrate``` and ```rails db:seed``` and populate database with 15 orders.

4. *(Optional)* run ```rails dev:resetup``` on console to drop, recreate, migrate and populate database.

## Tests
Run ```rails dev:tests``` or ```bundle exec rspec spec/requests/orders_spec.rb spec/requests/batches_spec.rb``` to execute tests.

*Postman also was used to test all the endpoints.*

## Actions and Methods
### Create an Order
POST - ```localhost:3000/api/v1/orders/```

##### Body e.g.
```
{
  "client_name": "G-Man",
  "purchase_channel": "Site EN",
  "address": "16238 Kent Shore, Ethanmouth, NE 71304",
  "delivery_service": "FEDEX",
  "total_value": "$ 100.00",
  "line_items": "[{sku: case-my-best-friend, model: iPhone X, case type: Rose Leather}]"
}
```
### Status of Orders
GET - ```localhost:3000/api/v1/orders/get_status```

##### Body e.g.
```
{
  "client_name": "G-Man"
}
or
{
  "reference": "EN000002"
}
or
{
  "client_name": "G-Man",
  "reference": "EN000002"
}
```
### List the Orders of a Purchase Channel
GET - ```localhost:3000/api/v1/orders/list_by```

##### Body e.g.
```
{
  "purchase_channel": "Site EN",
  "status": "closing"
}
```
### Create a Batch
POST - ```localhost:3000/api/v1/batches/```

##### Body e.g.
```
{
  "purchase_channel": "Site EN"
}
```
### Produce a Batch
POST - ```localhost:3000/api/v1/batches/mark_as_closing```

##### Body e.g.
```
{
  "reference": "202001-01"
}
```
### Send Orders in a Batch
POST - ```localhost:3000/api/v1/batches/mark_as_sent```

##### Body e.g.
```
{
  "reference": "202001-01",
  "delivery_service": "FEDEX"
}
```
