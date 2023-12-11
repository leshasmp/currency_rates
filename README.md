# Currency rates

## About
A ready-made chart for tracking exchange rates from https://www.cbr.ru/

## System requirements

* Ruby >= 3.2.2
* Node.js >= 20.9.0
* PostgreSQL

## Setup

```sh
make setup # will create exchange rates for the last month

make start # run server http://localhost:3000

make update-exchange-rates # save exchange rates every day according to schedule
```
