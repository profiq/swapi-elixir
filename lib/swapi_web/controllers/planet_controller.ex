defmodule SWAPIWeb.PlanetController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias SWAPI.Planets

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  tags ["planets"]

  operation :index,
    summary: "Get all planet resources",
    parameters: [
      search: [in: :query, description: "Search query", type: :string],
      page: [in: :query, description: "Page number", type: :integer]
    ],
    responses: [
      ok: {"List of planets", "application/json", SWAPIWeb.Schemas.PlanetList}
    ]

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {planets, meta}} <- Planets.search_planets(query, params) do
      render(conn, :index, planets: planets, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {planets, meta}} <- Planets.list_planets(params) do
      render(conn, :index, planets: planets, meta: meta)
    end
  end

  operation :show,
    summary: "Get a specific planet resource",
    parameters: [
      id: [in: :path, description: "Planet ID", type: :integer]
    ],
    responses: [
      ok: {"A planet", "application/json", SWAPIWeb.Schemas.Planet}
    ]

  def show(conn, %{"id" => id}) do
    planet = Planets.get_planet!(id)
    render(conn, :show, planet: planet)
  end
end
