# Elixir SWAPI
The [Star Wars API](https://swapi.dev/) (SWAPI), reimplemented in [Elixir](https://elixir-lang.org/).

We aim to be fully compatible with the original API, including pagination and search query parameters.

## Local setup
### Prerequisites
The following software is required for local development:
* Elixir 1.15
* Erlang/OTP 26

### Instructions
To start the server locally, follow these steps:

* Run `mix setup` to install and setup dependencies
* Start the API endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
