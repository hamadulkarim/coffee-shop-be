## Table of Contents

- [Main Characteristics](#main-characteristics)
- [Coffee Shop Walkthrough](#coffee-shop-walkthrough)
- [Getting Started](#getting-started)

## Main Characteristics

- Language: Ruby 2.7.2
- Framework: Rails 6.1.6
- Webserver: Puma
- Test Framework: RSpec
- Databases: Postgres

## Coffee Shop Walkthrough

#### User

Customers having first name, last name and email address.

#### Food

All the Food items available for buying. Each have their own tax rates as well as discount rates.

#### Cart

Customers are able to add items to cart in a session.

#### Order

Cart items can be finalized for placing an order.

## Getting Started

1.  Make sure that you have Rails 6, PostgreSQL, and bundle installed.
2.  Clone this repo using `git clone --depth=1 https://github.com/LoopStudio/rails-api-boilerplate.git <YOUR_PROJECT_NAME>`
3.  Run `bundle install`
4.  Run `bundle exec rake db:create`
5.  Run `bundle exec rake db:migrate`
6.  Run `bundle exec rake db:seed`
7.  Check the test are passing by running `rspec`
8.  Run `rails s` to run the server at port 3000.
9.  Test by making REST API calls through given postman collection.

## For API endpoints testing

1.  First login a user.
2.  Test other routes by filling the access-token, uid and client fields in the headers.
