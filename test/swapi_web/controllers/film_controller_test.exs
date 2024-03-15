defmodule SWAPIWeb.FilmControllerTest do
  use SWAPIWeb.ConnCase

  import SWAPI.FilmsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "returns empty list when there are no films", %{conn: conn} do
      conn = get(conn, ~p"/api/films")

      assert json_response(conn, 200) == %{
               "next" => nil,
               "previous" => nil,
               "results" => [],
               "count" => 0
             }
    end

    test "returns all films", %{conn: conn} do
      for _ <- 1..3 do
        film_fixture()
      end

      conn = get(conn, ~p"/api/films")

      assert %{
               "next" => _,
               "previous" => _,
               "results" => [_, _, _],
               "count" => 3
             } = json_response(conn, 200)
    end

    test "returns matched films when searching", %{conn: conn} do
      for i <- 1..3 do
        film_fixture(%{
          title: "Film #{i}"
        })
      end

      conn = get(conn, ~p"/api/films?search=\"Film 1\"")

      assert %{
               "next" => nil,
               "previous" => nil,
               "results" => [%{"id" => 1}],
               "count" => 1
             } = json_response(conn, 200)
    end
  end

  describe "show" do
    setup [:create_film]

    test "returns a single film", %{conn: conn, film: film} do
      conn = get(conn, ~p"/api/films/1")
      result = json_response(conn, 200)

      assert String.ends_with?(result["url"], "/api/films/1")
      assert result["title"] == film.title
    end
  end

  defp create_film(_) do
    film = film_fixture()
    %{film: film}
  end
end
