## Database and Model diagram
<img width="753" alt="image" src="https://github.com/user-attachments/assets/dbfb0384-e4b7-4bc3-81f3-f42f50e88d54">

## Design choices discussion

Description of some of the design choices I’ve encountered and why I’ve made them. I tried to stick to reasonable work time by simplifying when possible and cheap, but still made sure to detail how things could be changed or improved in further work.

1. I decided to merge `start_time` (datetime) and `duration` (int) into a `duration` range (tsrange) in Reservations table to simplify logic, improve query performance, and reduce room for bad data/erroneous states. As an API endpoint parameters they still exist per spec instructions. I also created a `timerange` Postgres range type (hence the switch from `schema.rb` to `structure.sql`)
2. Use restaurant row to represent one unique restaurant (with its own business hours, tables, etc’). The idea is to support several restaurants under one table reservation app. It also leaves an opening to later introduce a multi-tenant architecture, which will make the app much more powerful and cost effective to scale.
3. Instead of a restaurant’s own capacity field I decided that we can assume a restaurant’s capacity is measured by the capacity of the tables it has (so you can add/remove tables from a restaurant without also needing to update its capacity field each time), therefore reducing the possibility for bad or stale data.
4. Expressing the relationship between a `Table` and `Reservation`. Naive way is by adding `Table` a foreign key (`reservation_id` - “reservation has table/tables”). Problems: 1) Domain leak. Why does a table need to know what's a reservation? 2) Unnecessary writes into Table in reassigments, possible race conditions, and locks. 3) No records of previous tables associations with reservations 4) Query performance.  Some of these could be alleviated with another naive approach of having `tables_ids` array saved on a reservation, but not all. Solution: express the relationship through a “join table” (`reservation_tables`), which represents the association between a given reservation to its assigned tables.
5. The above also simplifies the logic of locking and releasing tables into a simple timestamp comparison query (vs more time intensive alternatives like: queue, mutex, tables pool etc’), with the disadvantage of being more strict (for example, not supporting "early release” of table if party finishes eating early in the restaurant). Even so, it makes it easier to add such functionality later if desired.
6. I implemented a naive first-come first-serve algorithm for the table assignment. It’s a greedy algorithm prioritizing reservations as they come and leaving as little unused capacity. Due to keeping with the time requirement I left it relatively simple, but given more time I would probably add a more involved implementation, like using simple combinatorics to support tables combinations (e.g. a party of 6 makes a reservation, but only a table of 2 and of 4 are available). The tradeoffs between different algorithms all revolve around resource intensity/performance vs maximizing capacity utilization of the tables. Another obvious thing to do would be to use a queue/background jobs + work with batches, instead of synchronously running the algorithm on every reservation creation, that way the algorithm is non-blocking.

More nice things to do not mentioned:

* Only allow to create reservations inside `business_hours`

## Setting things up and running

Easiest way to play around the data is to clone:

`git clone git@github.com:pugsiman/restaurant_reservations.git`

`cd restaurant_reservations`

`bundle`

Set up the database:

`rails db:create db:migrate db:seed`

from here you can log in to the console and play around

`rails c`
```ruby
Table.all
Reservations.all
reservation = Reservation.create!(restaurant: Restaurant.last, party_size: 2,  duration: DateTime.parse('2024/5/5 11:00')..DateTime.parse('2024/5/5 12:00'))
reservation.assign_tables!
```

## Testing the application directly
Span a server:

`rails s`

Test endpoints using cURL e.g.:

`reservations#create`
```shell
curl "localhost:3000/reservations/" -d '{"reservation":{"party_size":4, "restaurant_id":1, "duration":40, "start_time":"2024-10-07T05:12:40+00:00"}}' -X "POST" -H "Content-Type: application/json"
```

`tables#index` (before, during, after)
```shell
curl "localhost:3000/tables/occupied" -d '{"table":{"time":"2024-10-07T05:10:40+00:00"}}' -X "GET" -H "Content-Type: application/json"
curl "localhost:3000/tables/occupied" -d '{"table":{"time":"2024-10-07T05:22:40+00:00"}}' -X "GET" -H "Content-Type: application/json" 
curl "localhost:3000/tables/occupied" -d '{"table":{"time":"2024-10-07T06:22:40+00:00"}}' -X "GET" -H "Content-Type: application/json"
```

