defmodule SWAPIWeb.GraphQL.StarshipQueriesTest do
  use SWAPIWeb.ConnCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.PeopleFixtures
  import SWAPI.StarshipsFixtures

  alias SWAPI.Repo
  alias SWAPI.Schemas.Starship

  setup do
    starship =
      starship_fixture()
      |> Starship.changeset(%{transport: %{name: "X-wing"}})
      |> put_assoc(:films, [film_fixture()])
      |> put_assoc(:pilots, [person_fixture()])
      |> Repo.update!()

    {:ok, %{starship: starship}}
  end

  describe "allStarships" do
    test "returns all starships", %{conn: conn, starship: starship1} do
      starship2 = starship_fixture()

      query = """
        query {
          allStarships {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "allStarships" => [
                   %{"id" => starship1_id},
                   %{"id" => starship2_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^starship1_id = "#{starship1.id}"
      assert ^starship2_id = "#{starship2.id}"
    end
  end

  describe "searchStarships" do
    test "returns matching starships", %{conn: conn, starship: starship} do
      starship_fixture(%{name: "Millennium Falcon"})

      query = """
        query {
          searchStarships(searchTerms: ["X-wing"]) {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "searchStarships" => [
                   %{"id" => starship_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^starship_id = "#{starship.id}"
    end
  end

  describe "starship" do
    test "returns starship when it exists", %{conn: conn, starship: starship} do
      query = """
        query {
          starship(id: #{starship.id}) {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "starship" => %{"id" => starship_id}
               }
             } = json_response(conn, 200)

      assert ^starship_id = "#{starship.id}"
    end

    test "loads nested fields", %{conn: conn, starship: starship} do
      query = """
        query {
          starship(id: #{starship.id}) {
            id
            films {
              id
            }
            pilots {
              id
            }
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "starship" => %{
                   "id" => starship_id,
                   "films" => [%{"id" => film_id}],
                   "pilots" => [%{"id" => pilot_id}]
                 }
               }
             } = json_response(conn, 200)

      assert ^starship_id = "#{starship.id}"
      assert ^film_id = "#{List.first(starship.films).id}"
      assert ^pilot_id = "#{List.first(starship.pilots).id}"
    end

    test "handles recursive nesting", %{conn: conn, starship: starship} do
      query = """
        query {
          starship(id: #{starship.id}) {
            id
            pilots {
              id
              starships {
                id
              }
            }
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
               "data" => %{
                 "starship" => %{
                   "id" => starship_id,
                   "pilots" => [%{"id" => pilot_id, "starships" => [%{"id" => starship_id}]}]
                 }
               }
             } = json_response(conn, 200)

      assert ^starship_id = "#{starship.id}"
      assert ^pilot_id = "#{List.first(starship.pilots).id}"
    end
  end
end
