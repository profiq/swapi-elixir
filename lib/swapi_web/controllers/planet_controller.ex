defmodule SWAPIWeb.PlanetController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OpenApiSpex.Schema
  alias SWAPI.Planets

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  tags(["planets"])

  operation(:index,
    summary: "Get all planet resources",
    parameters: [
      search: [
        in: :query,
        description:
          "One or more search terms, which should be whitespace and/or comma separated. If multiple search terms are used then objects will be returned in the list only if all the provided terms are matched. Searches may contain quoted phrases with spaces, each phrase is considered as a single search term.",
        type: :string
      ],
      page: [
        in: :query,
        description: "Page number. Cannot be used together with `offset`.",
        schema: %Schema{
          type: :integer,
          minimum: 1,
          default: 1
        }
      ],
      offset: [
        in: :query,
        description: "Offset of the first item. Cannot be used together with `page`.",
        schema: %Schema{
          type: :integer,
          minimum: 0
        }
      ],
      limit: [
        in: :query,
        description: "Maximum number of items to return in the response.",
        schema: %Schema{
          type: :integer,
          minimum: 1,
          default: 10
        }
      ],
      format: [
        in: :query,
        description: "Specifies the encoding to be used for the response",
        schema: %Schema{
          type: :string,
          default: "json",
          enum: ["json", "wookiee"]
        }
      ]
    ],
    responses: [
      ok: {"List of planets", "application/json", SWAPIWeb.Schemas.PlanetList}
    ]
  )

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {planets, meta}} <- Planets.search_planets(query, params) do
      render(conn, :index, planets: Planets.preload_all(planets), meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {planets, meta}} <- Planets.list_planets(params) do
      render(conn, :index, planets: Planets.preload_all(planets), meta: meta)
    end
  end

  operation(:show,
    summary: "Get a specific planet resource",
    parameters: [
      id: [in: :path, description: "Planet ID", type: :integer],
      format: [
        in: :query,
        description: "Specifies the encoding to be used for the response",
        schema: %Schema{
          type: :string,
          default: "json",
          enum: ["json", "wookiee"]
        }
      ]
    ],
    responses: [
      ok: {"A planet", "application/json", SWAPIWeb.Schemas.Planet}
    ]
  )

  def show(conn, %{"id" => id}) do
    with {:ok, planet} <- Planets.get_planet(id) do
      render(conn, :show, planet: Planets.preload_all(planet))
    end
  end
end
