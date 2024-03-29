defmodule SWAPIWeb.PlanetJSON do
  use SWAPIWeb, :verified_routes

  alias SWAPI.Schemas.Planet

  import SWAPIWeb.Util

  @doc """
  Renders a list of planets.
  """
  def index(%{planets: planets, meta: meta, conn: conn}) do
    %{
      count: meta.count,
      next: page_url(conn, meta.next),
      previous: page_url(conn, meta.previous),
      results: for(planet <- planets, do: data(planet))
    }
  end

  @doc """
  Renders a single planet.
  """
  def show(%{planet: planet}), do: data(planet)

  defp data(%Planet{} = planet) do
    %{
      id: planet.id,
      name: planet.name,
      diameter: planet.diameter,
      rotation_period: planet.rotation_period,
      orbital_period: planet.orbital_period,
      gravity: planet.gravity,
      population: planet.population,
      climate: planet.climate,
      terrain: planet.terrain,
      surface_water: planet.surface_water,
      residents: for(resident <- planet.residents, do: url(~p"/api/people/#{resident.id}")),
      films: for(film <- planet.films, do: url(~p"/api/films/#{film.id}")),
      url: url(~p"/api/planets/#{planet.id}"),
      created: planet.created,
      edited: planet.edited
    }
  end
end
