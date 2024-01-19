defmodule SWAPIWeb.SpeciesJSON do
  use SWAPIWeb, :verified_routes

  alias SWAPI.Schemas.Species

  import SWAPIWeb.Util

  @doc """
  Renders a list of species.
  """
  def index(%{species: species, meta: meta, conn: conn}) do
    %{
      count: meta.count,
      next: page_url(conn, meta.next),
      previous: page_url(conn, meta.previous),
      results: for(species_item <- species, do: data(species_item))
    }
  end

  @doc """
  Renders a single species.
  """
  def show(%{species: species}), do: data(species)

  defp data(%Species{} = species) do
    %{
      id: species.id,
      name: species.name,
      classification: species.classification,
      designation: species.designation,
      average_height: species.average_height,
      average_lifespan: species.average_lifespan,
      eye_colors: species.eye_colors,
      hair_colors: species.hair_colors,
      skin_colors: species.skin_colors,
      language: species.language,
      homeworld: if(species.homeworld_id, do: url(~p"/api/planets/#{species.homeworld_id}")),
      people: for(person <- species.people, do: url(~p"/api/people/#{person.id}")),
      films: for(film <- species.films, do: url(~p"/api/films/#{film.id}")),
      url: url(~p"/api/species/#{species.id}"),
      created: species.created,
      edited: species.edited
    }
  end
end
