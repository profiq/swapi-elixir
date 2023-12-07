defmodule SWAPIWeb.FilmJSON do
  alias SWAPI.Schemas.Film

  import SWAPIWeb.Util

  use Phoenix.VerifiedRoutes, endpoint: SWAPIWeb.Endpoint, router: SWAPIWeb.Router

  @doc """
  Renders a list of films.
  """
  def index(%{films: films, meta: meta, conn: conn}) do
    %{
      count: meta.total_count,
      next: if(meta.next_page, do: append_query(conn, "page=#{meta.next_page}")),
      previous: if(meta.previous_page, do: append_query(conn, "page=#{meta.previous_page}")),
      results: for(film <- films, do: data(film))
    }
  end

  @doc """
  Renders a single film.
  """
  def show(%{film: film}), do: data(film)

  defp data(%Film{} = film) do
    %{
      title: film.title,
      episode_id: film.episode_id,
      opening_crawl: film.opening_crawl,
      director: film.director,
      producer: film.producer,
      release_date: film.release_date,
      species: for(species <- film.species, do: url(~p"/api/species/#{species.id}")),
      starships: for(starship <- film.starships, do: url(~p"/api/starships/#{starship.id}")),
      vehicles: for(vehicle <- film.vehicles, do: url(~p"/api/vehicles/#{vehicle.id}")),
      characters: for(character <- film.characters, do: url(~p"/api/people/#{character.id}")),
      planets: for(planet <- film.planets, do: url(~p"/api/planets/#{planet.id}")),
      url: url(~p"/api/films/#{film.id}"),
      created: film.created,
      edited: film.edited
    }
  end
end
