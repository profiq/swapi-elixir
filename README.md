# Elixir SWAPI
The [Star Wars API](https://swapi.dev/) (SWAPI), reimplemented in [Elixir](https://elixir-lang.org/).

This project aims to almost fully compatible with the original API, including pagination and search query parameters.

## Development
### Local environment
#### Prerequisites
The following software is required for local development:
* Elixir 1.15
* Erlang/OTP 26

#### Instructions
To start the server locally, follow these steps:

* Run `mix setup` to install and setup dependencies
* Start the API endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Docker
The server can also be started under Docker by running `docker compose -f dev/docker-compose.yml`. When started, the API will be accessible under the same port as when running locally ([`localhost:4000`](http://localhost:4000)).
