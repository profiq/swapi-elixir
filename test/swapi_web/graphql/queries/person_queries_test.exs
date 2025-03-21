defmodule SWAPIWeb.GraphQL.PersonQueriesTest do
  use SWAPIWeb.ConnCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.PeopleFixtures
  import SWAPI.PlanetsFixtures
  import SWAPI.SpeciesFixtures
  import SWAPI.StarshipsFixtures
  import SWAPI.VehiclesFixtures

  alias SWAPI.Repo
  alias SWAPI.Schemas.Person

  setup do
    person =
      person_fixture()
      |> Person.changeset(%{name: "Luke Skywalker"})
      |> put_assoc(:homeworld, planet_fixture())
      |> put_assoc(:films, [film_fixture()])
      |> put_assoc(:species, [species_fixture()])
      |> put_assoc(:starships, [starship_fixture()])
      |> put_assoc(:vehicles, [vehicle_fixture()])
      |> Repo.update!()

    {:ok, %{person: person}}
  end

  describe "allPeople" do
    test "returns all people", %{conn: conn, person: person1} do
      person2 = person_fixture()

      query = """
        query {
          allPeople {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "allPeople" => [
                   %{"id" => person1_id},
                   %{"id" => person2_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^person1_id = "#{person1.id}"
      assert ^person2_id = "#{person2.id}"
    end
  end

  describe "searchPeople" do
    test "returns matching people", %{conn: conn, person: person} do
      person_fixture(%{name: "Han Solo"})

      query = """
        query {
          searchPeople(searchTerms: ["Luke"]) {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "searchPeople" => [
                   %{"id" => person_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^person_id = "#{person.id}"
    end
  end

  describe "person" do
    test "returns person when it exists", %{conn: conn, person: person} do
      query = """
        query {
          person(id: #{person.id}) {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "person" => %{"id" => person_id}
               }
             } = json_response(conn, 200)

      assert ^person_id = "#{person.id}"
    end

    test "loads nested fields", %{conn: conn, person: person} do
      query = """
        query {
          person(id: #{person.id}) {
            id
            homeworld {
              id
            }
            films {
              id
            }
            species {
              id
            }
            starships {
              id
            }
            vehicles {
              id
            }
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "person" => %{
                   "id" => person_id,
                   "homeworld" => %{"id" => homeworld_id},
                   "films" => [%{"id" => film_id}],
                   "species" => [%{"id" => species_id}],
                   "starships" => [%{"id" => starship_id}],
                   "vehicles" => [%{"id" => vehicle_id}]
                 }
               }
             } = json_response(conn, 200)

      assert ^person_id = "#{person.id}"
      assert ^homeworld_id = "#{person.homeworld.id}"
      assert ^film_id = "#{List.first(person.films).id}"
      assert ^species_id = "#{List.first(person.species).id}"
      assert ^starship_id = "#{List.first(person.starships).id}"
      assert ^vehicle_id = "#{List.first(person.vehicles).id}"
    end

    test "handles recursive nesting", %{conn: conn, person: person} do
      query = """
        query {
          person(id: #{person.id}) {
            id
            films {
              id
              characters {
                id
              }
            }
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "person" => %{
                   "id" => person_id,
                   "films" => [%{"id" => film_id, "characters" => [%{"id" => person_id}]}]
                 }
               }
             } = json_response(conn, 200)

      assert ^person_id = "#{person.id}"
      assert ^film_id = "#{List.first(person.films).id}"
    end
  end
end
