defmodule SWAPIWeb.GraphQL.QueriesTests do
  use SWAPIWeb.ConnCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.PeopleFixtures
  import SWAPI.PlanetsFixtures
  import SWAPI.SpeciesFixtures
  import SWAPI.StarshipsFixtures
  import SWAPI.VehiclesFixtures

  alias SWAPI.Repo
  alias SWAPI.Schemas.Film

  setup do
    film =
      film_fixture()
      |> Film.changeset(%{title: "A New Hope"})
      |> put_assoc(:species, [species_fixture()])
      |> put_assoc(:starships, [starship_fixture()])
      |> put_assoc(:vehicles, [vehicle_fixture()])
      |> put_assoc(:characters, [person_fixture()])
      |> put_assoc(:planets, [planet_fixture()])
      |> Repo.update!()

    {:ok, %{film: film}}
  end

  describe "allFilms" do
    test "returns all films", %{conn: conn, film: film1} do
      film2 = film_fixture()

      query = """
        query {
          allFilms {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
              "data" => %{
                "allFilms" => [
                  %{"id" => film1_id},
                  %{"id" => film2_id}
                ]
              }
            } = json_response(conn, 200)

      assert ^film1_id = "#{film1.id}"
      assert ^film2_id = "#{film2.id}"
    end
  end

  describe "searchFilms" do
    test "returns matching films", %{conn: conn, film: film} do
      film_fixture(%{title: "Empire Strikes Back"})

      query = """
        query {
          searchFilms(searchTerms: ["Hope"]) {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
                "data" => %{
                  "searchFilms" => [
                    %{"id" => film_id}
                  ]
                }
              } = json_response(conn, 200)

      assert ^film_id = "#{film.id}"
    end
  end

  describe "film" do
    test "returns film when it exists", %{conn: conn, film: film} do
      query = """
        query {
          film(id: #{film.id}) {
            id
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
              "data" => %{
                "film" => %{"id" => film_id}
              }
            } = json_response(conn, 200)

      assert ^film_id = "#{film.id}"
    end

    test "loads nested fields", %{conn: conn, film: film} do
      query = """
        query {
          film(id: #{film.id}) {
            id
            species {
              id
            }
            starships {
              id
            }
            vehicles {
              id
            }
            characters {
              id
            }
            planets {
              id
            }
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
              "data" => %{
                "film" => %{
                    "id" => film_id,
                    "species" => [%{"id" => species_id}],
                    "starships" => [%{"id" => starship_id}],
                    "vehicles" => [%{"id" => vehicle_id}],
                    "characters" => [%{"id" => person_id}],
                    "planets" => [%{"id" => planet_id}]
                  }
              }
            } = json_response(conn, 200)

      assert ^film_id = "#{film.id}"
      assert ^species_id = "#{List.first(film.species).id}"
      assert ^starship_id = "#{List.first(film.starships).id}"
      assert ^vehicle_id = "#{List.first(film.vehicles).id}"
      assert ^person_id = "#{List.first(film.characters).id}"
      assert ^planet_id = "#{List.first(film.planets).id}"
    end

    test "handles recursive nesting", %{conn: conn, film: film} do
      query = """
        query {
          film(id: #{film.id}) {
            id
            characters {
              id
              films {
                id
              }
            }
          }
        }
      """

      conn = get(conn, "/graphql", query: query)

      assert %{
              "data" => %{
                "film" => %{
                    "id" => film_id,
                    "characters" => [%{"id" => person_id, "films" => [%{"id" => film_id}]}]
                  }
              }
            } = json_response(conn, 200)

      assert ^film_id = "#{film.id}"
      assert ^person_id = "#{List.first(film.characters).id}"
    end
  end
end
