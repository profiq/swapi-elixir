defmodule SWAPIWeb.VehicleControllerTest do
  use SWAPIWeb.ConnCase

  import SWAPI.VehiclesFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "returns empty list when there are no vehicles", %{conn: conn} do
      conn = get(conn, ~p"/api/vehicles")

      assert json_response(conn, 200) == %{
               "next" => nil,
               "previous" => nil,
               "results" => [],
               "count" => 0
             }
    end

    test "returns all vehicles", %{conn: conn} do
      for _ <- 1..3 do
        vehicle_fixture()
      end

      conn = get(conn, ~p"/api/vehicles")

      assert %{
               "next" => _,
               "previous" => _,
               "results" => [_, _, _],
               "count" => 3
             } = json_response(conn, 200)
    end

    test "returns matched vehicles when searching", %{conn: conn} do
      for i <- 1..3 do
        vehicle_fixture(%{
          transport: %{
            name: "Vehicle #{i}"
          }
        })
      end

      conn = get(conn, ~p"/api/vehicles?search=\"Vehicle 1\"")

      assert %{
               "next" => nil,
               "previous" => nil,
               "results" => [%{"id" => 1}],
               "count" => 1
             } = json_response(conn, 200)
    end
  end

  describe "show" do
    setup [:create_vehicle]

    test "returns a single vehicle", %{conn: conn, vehicle: vehicle} do
      conn = get(conn, ~p"/api/vehicles/1")
      result = json_response(conn, 200)

      assert String.ends_with?(result["url"], "/api/vehicles/1")
      assert result["name"] == vehicle.transport.name
    end
  end

  defp create_vehicle(_) do
    vehicle = vehicle_fixture()
    %{vehicle: vehicle}
  end
end
