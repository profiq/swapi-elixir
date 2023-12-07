defmodule SWAPIWeb.PersonJSON do
  alias SWAPI.Schemas.Person

  use Phoenix.VerifiedRoutes, endpoint: SWAPIWeb.Endpoint, router: SWAPIWeb.Router

  @doc """
  Renders a list of people.
  """
  def index(%{people: people}) do
    %{
      count: length(people),
      next: nil,
      previous: nil,
      results: for(person <- people, do: data(person))
    }
  end

  @doc """
  Renders a single person.
  """
  def show(%{person: person}), do: data(person)

  defp data(%Person{} = person) do
    %{
      name: person.name,
      birth_year: person.birth_year,
      eye_color: person.eye_color,
      gender: person.gender,
      hair_color: person.hair_color,
      height: person.height,
      mass: person.mass,
      skin_color: person.skin_color,
      homeworld: url(~p"/api/planets/#{person.homeworld_id}"),
      films: for(film <- person.films, do: url(~p"/api/films/#{film.id}")),
      species: for(species <- person.species, do: url(~p"/api/species/#{species.id}")),
      vehicles: for(vehicle <- person.vehicles, do: url(~p"/api/vehicles/#{vehicle.id}")),
      starships: for(starship <- person.starships, do: url(~p"/api/starships/#{starship.id}")),
      url: url(~p"/api/people/#{person.id}"),
      created: person.created,
      edited: person.edited
    }
  end
end
