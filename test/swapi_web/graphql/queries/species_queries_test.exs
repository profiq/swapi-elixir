defmodule SWAPIWeb.GraphQL.SpeciesQueriesTest do
  use SWAPIWeb.ConnCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.PeopleFixtures
  import SWAPI.PlanetsFixtures
  import SWAPI.SpeciesFixtures

  alias SWAPI.Repo
  alias SWAPI.Schemas.Species

  setup do
    species =
      species_fixture()
      |> Species.changeset(%{name: "Human"})
      |> put_assoc(:homeworld, planet_fixture())
      |> put_assoc(:films, [film_fixture()])
      |> put_assoc(:people, [person_fixture()])
      |> Repo.update!()

    {:ok, %{species: species}}
  end

  describe "allSpecies" do
    test "returns all species", %{conn: conn, species: species1} do
      species2 = species_fixture()

      query = """
        query {
          allSpecies {
            id
          }
        }
      """

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "allSpecies" => [
                   %{"id" => species1_id},
                   %{"id" => species2_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^species1_id = "#{species1.id}"
      assert ^species2_id = "#{species2.id}"
    end
  end

  describe "searchSpecies" do
    test "returns matching species", %{conn: conn, species: species} do
      species_fixture(%{name: "Wookiee"})

      query = """
        query {
          searchSpecies(searchTerms: ["Human"]) {
            id
          }
        }
      """

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "searchSpecies" => [
                   %{"id" => species_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^species_id = "#{species.id}"
    end
  end

  describe "species" do
    test "returns species when it exists", %{conn: conn, species: species} do
      query = """
        query {
          species(id: #{species.id}) {
            id
          }
        }
      """

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "species" => %{"id" => species_id}
               }
             } = json_response(conn, 200)

      assert ^species_id = "#{species.id}"
    end

    test "loads nested fields", %{conn: conn, species: species} do
      query = """
        query {
          species(id: #{species.id}) {
            id
            homeworld {
              id
            }
            films {
              id
            }
            people {
              id
            }
          }
        }
      """

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "species" => %{
                   "id" => species_id,
                   "homeworld" => %{"id" => homeworld_id},
                   "films" => [%{"id" => film_id}],
                   "people" => [%{"id" => person_id}]
                 }
               }
             } = json_response(conn, 200)

      assert ^species_id = "#{species.id}"
      assert ^homeworld_id = "#{species.homeworld.id}"
      assert ^film_id = "#{List.first(species.films).id}"
      assert ^person_id = "#{List.first(species.people).id}"
    end

    test "handles recursive nesting", %{conn: conn, species: species} do
      query = """
        query {
          species(id: #{species.id}) {
            id
            people {
              id
              species {
                id
              }
            }
          }
        }
      """

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "species" => %{
                   "id" => species_id,
                   "people" => [%{"id" => person_id, "species" => [%{"id" => species_id}]}]
                 }
               }
             } = json_response(conn, 200)

      assert ^species_id = "#{species.id}"
      assert ^person_id = "#{List.first(species.people).id}"
    end
  end
end
