defmodule SWAPIWeb.SpeciesController do
  use SWAPIWeb, :controller

  alias SWAPI.Species

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

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

  def show(conn, %{"id" => id}) do
    species = Species.get_species!(id)
    render(conn, :show, species: species)
  end
end
