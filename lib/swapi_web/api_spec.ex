defmodule SWAPIWeb.ApiSpec do
  @moduledoc """
  OpenAPI specification module
  """

  alias OpenApiSpex.Info
  alias OpenApiSpex.OpenApi
  alias OpenApiSpex.Paths
  alias OpenApiSpex.Server
  alias SWAPIWeb.Endpoint
  alias SWAPIWeb.Router
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Elixir SWAPI",
        description: "The Star Wars API, reimplemented in Elixir",
        version: "0.1.0"
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
