# Elixir SWAPI

Hosted at https://swapi.profiq.com

Dev is deployed to https://swapi-dev.profiq.com

The [Star Wars API](https://swapi.dev/) (SWAPI), reimplemented in [Elixir](https://elixir-lang.org/).

This project aims to almost fully compatible with the original API, including pagination and search query parameters.

## Development
### Local environment
#### Prerequisites
The following software is required for local development:
* Elixir 1.15
* Erlang/OTP 26
* NodeJS 18+

#### Instructions
To start the server locally, follow these steps:

* Run `yarn` inside folder `assets` to install JavaScript dependencies
* Run `mix setup` to install and setup dependencies
* Start the API endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Docker
The server can also be started under Docker by running `docker compose -f dev/docker-compose.yml up`. When started, the API will be accessible under the same port as when running locally ([`localhost:4000`](http://localhost:4000)).

## Common tasks
### Updating the Postman collection

The Postman collection is stored in `priv/static/downloads/swapi.postman_collection.json`. Whenever the API documentation changes, the collection should be updated to match.

You can generate a new collection file as follows:
1. Start the server.
2. Click "Import" in the workspace sidebar in Postman, enter the URL to the OpenAPI doc, e.g. `http://localhost:4000/api/openapi` and import the API as a Postman collection.
3. Open the "Elixir SWAPI" collection, go to the Variables tab in the main pane and change the `baseUrl` variable to `https://swapi.profiq.com`.
4. Right-click the "Elixir SWAPI" collection, click "Export" and choose the Collection 2.1 format.
5. Copy the exported collection to `priv/static/downloads/swapi.postman_collection.json`.
