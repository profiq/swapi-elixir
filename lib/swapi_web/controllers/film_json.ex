defmodule SWAPIWeb.FilmJSON do
  alias SWAPI.Schemas.Film

  use Phoenix.VerifiedRoutes, endpoint: SWAPIWeb.Endpoint, router: SWAPIWeb.Router

  @doc """
  Renders a list of films.
  """
  def index(%{films: films}) do
    %{
      count: length(films),
      next: nil,
      previous: nil,
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
