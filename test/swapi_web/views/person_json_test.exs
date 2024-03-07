defmodule SWAPIWeb.PersonJSONTest do
  use SWAPI.DataCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.PeopleFixtures
  import SWAPI.PlanetsFixtures
  import SWAPI.SpeciesFixtures
  import SWAPI.StarshipsFixtures
  import SWAPI.VehiclesFixtures

  alias SWAPI.Schemas.Person
  alias SWAPIWeb.PersonJSON

  describe "show" do
    setup do
      person =
        person_fixture()
        |> Person.changeset(%{homeworld_id: planet_fixture().id})
        |> put_assoc(:films, [film_fixture()])
        |> put_assoc(:species, [species_fixture()])
        |> put_assoc(:starships, [starship_fixture()])
        |> put_assoc(:vehicles, [vehicle_fixture()])
        |> Repo.update!()

      {:ok, %{person: person}}
    end

    test "renders an item", %{person: person} do
      assert %{
               id: id,
               name: name,
               birth_year: birth_year,
               eye_color: eye_color,
               gender: gender,
               hair_color: hair_color,
               height: height,
               mass: mass,
               skin_color: skin_color,
               homeworld: homeworld_url,
               films: [film_url],
               species: [species_url],
               starships: [starship_url],
               vehicles: [vehicle_url],
               url: url,
               created: created,
               edited: edited
             } = PersonJSON.show(%{person: person})

      assert id == person.id
      assert name == person.name
      assert birth_year == person.birth_year
      assert eye_color == person.eye_color
      assert gender == person.gender
      assert hair_color == person.hair_color
      assert height == person.height
      assert mass == person.mass
      assert skin_color == person.skin_color
      assert created == person.created
      assert edited == person.edited

      assert String.ends_with?(url, "/api/people/#{person.id}")
      assert String.ends_with?(homeworld_url, "/api/planets/#{person.homeworld_id}")
      assert String.ends_with?(film_url, "/api/films/#{List.first(person.films).id}")
      assert String.ends_with?(species_url, "/api/species/#{List.first(person.species).id}")
      assert String.ends_with?(starship_url, "/api/starships/#{List.first(person.starships).id}")
      assert String.ends_with?(vehicle_url, "/api/vehicles/#{List.first(person.vehicles).id}")
    end
  end

  describe "index" do
    setup do
      people = for _ <- 1..10, do: person_fixture()
      meta = %{count: length(people), next: nil, previous: nil}
      conn = %Plug.Conn{request_path: "/api/people", query_params: %{"page" => 1}}

      {:ok, %{people: people, meta: meta, conn: conn}}
    end

    test "renders a list of items", %{people: people, meta: meta, conn: conn} do
      assert %{
               count: count,
               next: nil,
               previous: nil,
               results: results
             } = PersonJSON.index(%{people: people, meta: meta, conn: conn})

      assert count == meta.count
      assert is_list(results)
      assert length(results) == length(people)
    end

    test "puts a link to next page if there is one", %{people: people, meta: meta, conn: conn} do
      meta = %{meta | next: {:page, 2}}

      assert %{
               count: _count,
               next: next_url,
               previous: nil,
               results: _results
             } = PersonJSON.index(%{people: people, meta: meta, conn: conn})

      assert String.ends_with?(next_url, "/api/people?page=2")
    end

    test "puts a link to previous page if there is one", %{people: people, meta: meta, conn: conn} do
      meta = %{meta | previous: {:page, 2}}

      assert %{
               count: _count,
               next: nil,
               previous: previous_url,
               results: _results
             } = PersonJSON.index(%{people: people, meta: meta, conn: conn})

      assert String.ends_with?(previous_url, "/api/people?page=2")
    end
  end
end
