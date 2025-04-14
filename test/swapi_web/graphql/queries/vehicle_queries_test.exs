defmodule SWAPIWeb.GraphQL.VehicleQueriesTest do
  use SWAPIWeb.ConnCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.PeopleFixtures
  import SWAPI.VehiclesFixtures

  alias SWAPI.Repo
  alias SWAPI.Schemas.Vehicle

  setup do
    vehicle =
      vehicle_fixture()
      |> Vehicle.changeset(%{transport: %{name: "Snowspeeder"}})
      |> put_assoc(:films, [film_fixture()])
      |> put_assoc(:pilots, [person_fixture()])
      |> Repo.update!()

    {:ok, %{vehicle: vehicle}}
  end

  describe "allVehicles" do
    test "returns all vehicles", %{conn: conn, vehicle: vehicle1} do
      vehicle2 = vehicle_fixture()

      query = """
        query {
          allVehicles {
            id
          }
        }
      """

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "allVehicles" => [
                   %{"id" => vehicle1_id},
                   %{"id" => vehicle2_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^vehicle1_id = "#{vehicle1.id}"
      assert ^vehicle2_id = "#{vehicle2.id}"
    end
  end

  describe "searchVehicles" do
    test "returns matching vehicles", %{conn: conn, vehicle: vehicle} do
      vehicle_fixture(%{name: "AT-AT"})

      query = """
        query {
          searchVehicles(searchTerms: ["Snowspeeder"]) {
            id
          }
        }
      """

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "searchVehicles" => [
                   %{"id" => vehicle_id}
                 ]
               }
             } = json_response(conn, 200)

      assert ^vehicle_id = "#{vehicle.id}"
    end
  end

  describe "vehicle" do
    test "returns vehicle when it exists", %{conn: conn, vehicle: vehicle} do
      query = """
        query {
          vehicle(id: #{vehicle.id}) {
            id
          }
        }
      """

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "vehicle" => %{"id" => vehicle_id}
               }
             } = json_response(conn, 200)

      assert ^vehicle_id = "#{vehicle.id}"
    end

    test "loads nested fields", %{conn: conn, vehicle: vehicle} do
      query = """
        query {
          vehicle(id: #{vehicle.id}) {
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

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "vehicle" => %{
                   "id" => vehicle_id,
                   "films" => [%{"id" => film_id}],
                   "pilots" => [%{"id" => pilot_id}]
                 }
               }
             } = json_response(conn, 200)

      assert ^vehicle_id = "#{vehicle.id}"
      assert ^film_id = "#{List.first(vehicle.films).id}"
      assert ^pilot_id = "#{List.first(vehicle.pilots).id}"
    end

    test "handles recursive nesting", %{conn: conn, vehicle: vehicle} do
      query = """
        query {
          vehicle(id: #{vehicle.id}) {
            id
            pilots {
              id
              vehicles {
                id
              }
            }
          }
        }
      """

      conn = get(conn, "/api/graphql", query: query)

      assert %{
               "data" => %{
                 "vehicle" => %{
                   "id" => vehicle_id,
                   "pilots" => [%{"id" => pilot_id, "vehicles" => [%{"id" => vehicle_id}]}]
                 }
               }
             } = json_response(conn, 200)

      assert ^vehicle_id = "#{vehicle.id}"
      assert ^pilot_id = "#{List.first(vehicle.pilots).id}"
    end
  end
end
