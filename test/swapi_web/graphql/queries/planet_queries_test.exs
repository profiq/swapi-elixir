defmodule SWAPIWeb.GraphQL.PlanetQueriesTest do
  use SWAPIWeb.ConnCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.PeopleFixtures
  import SWAPI.PlanetsFixtures

  alias SWAPI.Repo
  alias SWAPI.Schemas.Planet

  setup do
    planet =
      planet_fixture()
      |> Planet.changeset(%{name: "Tatooine"})
      |> put_assoc(:films, [film_fixture()])
      |> put_assoc(:residents, [person_fixture()])
      |> Repo.update!()

    {:ok, %{planet: planet}}
  end

  describe "allPlanets" do
    test "returns all planets", %{conn: conn, planet: planet1} do
      planet2 = planet_fixture()

      query = """
        query {
          allPlanets {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "allPlanets" => [
                   %{"id" => planet1_id},
                   %{"id" => planet2_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^planet1_id = "#{planet1.id}"
      assert ^planet2_id = "#{planet2.id}"
    end
  end

  describe "searchPlanets" do
    test "returns matching planets", %{conn: conn, planet: planet} do
      planet_fixture(%{name: "Alderaan"})

      query = """
        query {
          searchPlanets(searchTerms: ["Tatooine"]) {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "searchPlanets" => [
                   %{"id" => planet_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^planet_id = "#{planet.id}"
    end
  end

  describe "planet" do
    test "returns planet when it exists", %{conn: conn, planet: planet} do
      query = """
        query {
          planet(id: #{planet.id}) {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "planet" => %{"id" => planet_id}
               }
             } = json_response(conn, 200)

      assert ^planet_id = "#{planet.id}"
    end

    test "loads nested fields", %{conn: conn, planet: planet} do
      query = """
        query {
          planet(id: #{planet.id}) {
            id
            films {
              id
            }
            residents {
              id
            }
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "planet" => %{
                   "id" => planet_id,
                   "films" => [%{"id" => film_id}],
                   "residents" => [%{"id" => resident_id}]
                 }
               }
             } = json_response(conn, 200)

      assert ^planet_id = "#{planet.id}"
      assert ^film_id = "#{List.first(planet.films).id}"
      assert ^resident_id = "#{List.first(planet.residents).id}"
    end

    test "handles recursive nesting", %{conn: conn, planet: planet} do
      query = """
        query {
          planet(id: #{planet.id}) {
            id
            residents {
              id
              homeworld {
                id
              }
            }
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "planet" => %{
                   "id" => planet_id,
                   "residents" => [%{"id" => resident_id, "homeworld" => %{"id" => planet_id}}]
                 }
               }
             } = json_response(conn, 200)

      assert ^planet_id = "#{planet.id}"
      assert ^resident_id = "#{List.first(planet.residents).id}"
    end
  end
end
