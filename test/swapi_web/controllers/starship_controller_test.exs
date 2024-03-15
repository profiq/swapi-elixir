defmodule SWAPIWeb.StarshipControllerTest do
  use SWAPIWeb.ConnCase

  import SWAPI.StarshipsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "returns empty list when there are no starships", %{conn: conn} do
      conn = get(conn, ~p"/api/starships")

      assert json_response(conn, 200) == %{
               "next" => nil,
               "previous" => nil,
               "results" => [],
               "count" => 0
             }
    end

    test "returns all starships", %{conn: conn} do
      for _ <- 1..3 do
        starship_fixture()
      end

      conn = get(conn, ~p"/api/starships")

      assert %{
               "next" => _,
               "previous" => _,
               "results" => [_, _, _],
               "count" => 3
             } = json_response(conn, 200)
    end

    test "returns matched starships when searching", %{conn: conn} do
      for i <- 1..3 do
        starship_fixture(%{
          transport: %{
            name: "Starship #{i}"
          }
        })
      end

      conn = get(conn, ~p"/api/starships?search=\"Starship 1\"")

      assert %{
               "next" => nil,
               "previous" => nil,
               "results" => [%{"id" => 1}],
               "count" => 1
             } = json_response(conn, 200)
    end
  end

  describe "show" do
    setup [:create_starship]

    test "returns a single starship", %{conn: conn, starship: starship} do
      conn = get(conn, ~p"/api/starships/1")
      result = json_response(conn, 200)

      assert String.ends_with?(result["url"], "/api/starships/1")
      assert result["name"] == starship.transport.name
    end
  end

  defp create_starship(_) do
    starship = starship_fixture()
    %{starship: starship}
  end
end
