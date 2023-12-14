defmodule SWAPIWeb.StarshipController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias SWAPI.Starships

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  tags ["starships"]

  operation :index,
    summary: "Get all starship resources",
    parameters: [
      search: [in: :query, description: "Search query", type: :string],
      page: [in: :query, description: "Page number", type: :integer]
    ],
    responses: [
      ok: {"List of starships", "application/json", SWAPIWeb.Schemas.StarshipList}
    ]

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

  operation :show,
    summary: "Get a specific starship resource",
    parameters: [
      id: [in: :path, description: "Starship ID", type: :integer]
    ],
    responses: [
      ok: {"A starship", "application/json", SWAPIWeb.Schemas.Starship}
    ]

  def show(conn, %{"id" => id}) do
    with {:ok, starship} <- Starships.get_starship(id) do
      render(conn, :show, starship: starship)
    end
  end
end
