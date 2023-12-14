defmodule SWAPIWeb.SpeciesController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias SWAPI.Species

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  tags ["species"]

  operation :index,
    summary: "Get all species resources",
    parameters: [
      search: [in: :query, description: "Search query", type: :string],
      page: [in: :query, description: "Page number", type: :integer]
    ],
    responses: [
      ok: {"List of species", "application/json", SWAPIWeb.Schemas.SpeciesList}
    ]

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {species, meta}} <- Species.search_species(query, params) do
      render(conn, :index, species: species, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {species, meta}} <- Species.list_species(params) do
      render(conn, :index, species: species, meta: meta)
    end
  end

  operation :show,
    summary: "Get a specific species resource",
    parameters: [
      id: [in: :path, description: "Species ID", type: :integer]
    ],
    responses: [
      ok: {"A species", "application/json", SWAPIWeb.Schemas.Species}
    ]

  def show(conn, %{"id" => id}) do
    species = Species.get_species!(id)
    render(conn, :show, species: species)
  end
end
