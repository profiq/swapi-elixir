defmodule SWAPIWeb.SpeciesControllerTest do
  use SWAPIWeb.ConnCase

  import SWAPI.SpeciesFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "returns empty list when there are no species", %{conn: conn} do
      conn = get(conn, ~p"/api/species")

      assert json_response(conn, 200) == %{
               "next" => nil,
               "previous" => nil,
               "results" => [],
               "count" => 0
             }
    end

    test "returns all species", %{conn: conn} do
      for _ <- 1..3 do
        species_fixture()
      end

      conn = get(conn, ~p"/api/species")

      assert %{
               "next" => _,
               "previous" => _,
               "results" => [_, _, _],
               "count" => 3
             } = json_response(conn, 200)
    end

    test "returns matched species when searching", %{conn: conn} do
      for i <- 1..3 do
        species_fixture(%{
          name: "Species #{i}"
        })
      end

      conn = get(conn, ~p"/api/species?search=\"Species 1\"")

      assert %{
               "next" => nil,
               "previous" => nil,
               "results" => [%{"id" => 1}],
               "count" => 1
             } = json_response(conn, 200)
    end
  end

  describe "show" do
    setup [:create_species]

    test "returns a single species", %{conn: conn, species: species} do
      conn = get(conn, ~p"/api/species/1")
      result = json_response(conn, 200)

      assert String.ends_with?(result["url"], "/api/species/1")
      assert result["name"] == species.name
    end
  end

  defp create_species(_) do
    species = species_fixture()
    %{species: species}
  end
end
