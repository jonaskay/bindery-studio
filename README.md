# bindery-studio

## Requirements

* [Docker Engine](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)

## Development

To start the app locally, run

    $ docker-compose up

To create the database and run migrations, run

    $ docker-compose run --rm app bin/rails db:prepare

## Tests

To run tests in watch mode using guard, run

    $ docker-compose run --use-aliases --rm test bundle exec guard
