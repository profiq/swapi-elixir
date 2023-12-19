defmodule SWAPIWeb.StarshipJSON do
  use SWAPIWeb, :verified_routes

  alias SWAPI.Schemas.Starship
  alias SWAPI.Schemas.Transport

  import SWAPIWeb.Util

  @doc """
  Renders a list of starships.
  """
  def index(%{starships: starships, meta: meta, conn: conn}) do
    %{
      count: meta.total_count,
      next: page_url(conn, meta.next_page),
      previous: page_url(conn, meta.previous_page),
      results: for(starship <- starships, do: data(starship))
    }
  end

  @doc """
  Renders a single starship.
  """
  def show(%{starship: starship}), do: data(starship)

  defp data(%Starship{transport: %Transport{} = transport} = starship) do
    %{
      name: transport.name,
      model: transport.model,
      starship_class: starship.starship_class,
      manufacturer: transport.manufacturer,
      cost_in_credits: transport.cost_in_credits,
      length: transport.length,
      crew: transport.crew,
      passengers: transport.passengers,
      max_atmosphering_speed: transport.max_atmosphering_speed,
      hyperdrive_rating: starship.hyperdrive_rating,
      MGLT: starship.mglt,
      cargo_capacity: transport.cargo_capacity,
      consumables: transport.consumables,
      films: for(film <- starship.films, do: url(~p"/api/films/#{film.id}")),
      pilots: for(pilot <- starship.pilots, do: url(~p"/api/people/#{pilot.id}")),
      url: url(~p"/api/starships/#{starship.id}"),
      created: transport.created,
      edited: transport.edited
    }
  end
end
