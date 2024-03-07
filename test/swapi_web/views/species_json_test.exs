defmodule SWAPIWeb.SpeciesJSONTest do
  use SWAPI.DataCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.SpeciesFixtures
  import SWAPI.PeopleFixtures
  import SWAPI.PlanetsFixtures

  alias SWAPI.Schemas.Species
  alias SWAPIWeb.SpeciesJSON

  describe "show" do
    setup do
      species =
        species_fixture()
        |> Species.changeset(%{homeworld_id: planet_fixture().id})
        |> put_assoc(:people, [person_fixture()])
        |> put_assoc(:films, [film_fixture()])
        |> Repo.update!()

      {:ok, %{species: species}}
    end

    test "renders an item", %{species: species} do
      assert %{
               id: id,
               name: name,
               classification: classification,
               designation: designation,
               average_height: average_height,
               average_lifespan: average_lifespan,
               eye_colors: eye_colors,
               hair_colors: hair_colors,
               skin_colors: skin_colors,
               language: language,
               homeworld: homeworld_url,
               people: [person_url],
               films: [film_url],
               url: url,
               created: created,
               edited: edited
             } = SpeciesJSON.show(%{species: species})

      assert id == species.id
      assert name == species.name
      assert classification == species.classification
      assert designation == species.designation
      assert average_height == species.average_height
      assert average_lifespan == species.average_lifespan
      assert eye_colors == species.eye_colors
      assert hair_colors == species.hair_colors
      assert skin_colors == species.skin_colors
      assert language == species.language
      assert created == species.created
      assert edited == species.edited

      assert String.ends_with?(url, "/api/species/#{species.id}")
      assert String.ends_with?(homeworld_url, "/api/planets/#{species.homeworld_id}")
      assert String.ends_with?(person_url, "/api/people/#{List.first(species.people).id}")
      assert String.ends_with?(film_url, "/api/films/#{List.first(species.films).id}")
    end
  end

  describe "index" do
    setup do
      species = for _ <- 1..10, do: species_fixture()
      meta = %{count: length(species), next: nil, previous: nil}
      conn = %Plug.Conn{request_path: "/api/species", query_params: %{"page" => 1}}

      {:ok, %{species: species, meta: meta, conn: conn}}
    end

    test "renders a list of items", %{species: species, meta: meta, conn: conn} do
      assert %{
               count: count,
               next: nil,
               previous: nil,
               results: results
             } = SpeciesJSON.index(%{species: species, meta: meta, conn: conn})

      assert count == meta.count
      assert is_list(results)
      assert length(results) == length(species)
    end

    test "puts a link to next page if there is one", %{species: species, meta: meta, conn: conn} do
      meta = %{meta | next: {:page, 2}}

      assert %{
               count: _count,
               next: next_url,
               previous: nil,
               results: _results
             } = SpeciesJSON.index(%{species: species, meta: meta, conn: conn})

      assert String.ends_with?(next_url, "/api/species?page=2")
    end

    test "puts a link to previous page if there is one", %{
      species: species,
      meta: meta,
      conn: conn
    } do
      meta = %{meta | previous: {:page, 2}}

      assert %{
               count: _count,
               next: nil,
               previous: previous_url,
               results: _results
             } = SpeciesJSON.index(%{species: species, meta: meta, conn: conn})

      assert String.ends_with?(previous_url, "/api/species?page=2")
    end
  end
end
