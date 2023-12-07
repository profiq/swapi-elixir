defmodule SWAPIWeb.SpeciesController do
  use SWAPIWeb, :controller

  alias SWAPI.Species, as: SpeciesContext
  alias SWAPI.Schemas.Species

  action_fallback SWAPIWeb.FallbackController

  def index(conn, params) do
    with {:ok, {species, meta}} <- SpeciesContext.list_species(params) do
      render(conn, :index, species: species, meta: meta)
    end
  end

  def create(conn, %{"species" => species_params}) do
    with {:ok, %Species{} = species} <- SpeciesContext.create_species(species_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/species/#{species}")
      |> render(:show, species: species)
    end
  end

  def show(conn, %{"id" => id}) do
    species = SpeciesContext.get_species!(id)
    render(conn, :show, species: species)
  end

  def update(conn, %{"id" => id, "species" => species_params}) do
    species = SpeciesContext.get_species!(id)

    with {:ok, %Species{} = species} <- SpeciesContext.update_species(species, species_params) do
      render(conn, :show, species: species)
    end
  end

  def delete(conn, %{"id" => id}) do
    species = SpeciesContext.get_species!(id)

    with {:ok, %Species{}} <- SpeciesContext.delete_species(species) do
      send_resp(conn, :no_content, "")
    end
  end
end
