defmodule SWAPIWeb.PlanetControllerTest do
  use SWAPIWeb.ConnCase

  import SWAPI.PlanetsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "returns empty list when there are no planets", %{conn: conn} do
      conn = get(conn, ~p"/api/planets")

      assert json_response(conn, 200) == %{
               "next" => nil,
               "previous" => nil,
               "results" => [],
               "count" => 0
             }
    end

    test "returns all planets", %{conn: conn} do
      for _ <- 1..3 do
        planet_fixture()
      end

      conn = get(conn, ~p"/api/planets")

      assert %{
               "next" => _,
               "previous" => _,
               "results" => [_, _, _],
               "count" => 3
             } = json_response(conn, 200)
    end

    test "returns matched planets when searching", %{conn: conn} do
      for i <- 1..3 do
        planet_fixture(%{
          name: "Planet #{i}"
        })
      end

      conn = get(conn, ~p"/api/planets?search=\"Planet 1\"")

      assert %{
               "next" => nil,
               "previous" => nil,
               "results" => [%{"id" => 1}],
               "count" => 1
             } = json_response(conn, 200)
    end
  end

  describe "show" do
    setup [:create_planet]

    test "returns a single planet", %{conn: conn, planet: planet} do
      conn = get(conn, ~p"/api/planets/1")
      result = json_response(conn, 200)

      assert String.ends_with?(result["url"], "/api/planets/1")
      assert result["name"] == planet.name
    end
  end

  defp create_planet(_) do
    planet = planet_fixture()
    %{planet: planet}
  end
end
