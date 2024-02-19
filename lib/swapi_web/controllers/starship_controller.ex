defmodule SWAPIWeb.StarshipController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OpenApiSpex.Schema
  alias SWAPI.Starships

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  tags(["starships"])

  operation(:index,
    summary: "Get all starship resources",
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
      ]
    ],
    responses: [
      ok: {"List of starships", "application/json", SWAPIWeb.Schemas.StarshipList}
    ]
  )

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {starships, meta}} <- Starships.search_starships(query, params) do
      render(conn, :index, starships: starships, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {starships, meta}} <- Starships.list_starships(params) do
      render(conn, :index, starships: starships, meta: meta)
    end
  end

  operation(:show,
    summary: "Get a specific starship resource",
    parameters: [
      id: [in: :path, description: "Starship ID", type: :integer]
    ],
    responses: [
      ok: {"A starship", "application/json", SWAPIWeb.Schemas.Starship}
    ]
  )

  def show(conn, %{"id" => id}) do
    with {:ok, starship} <- Starships.get_starship(id) do
      render(conn, :show, starship: starship)
    end
  end
end
