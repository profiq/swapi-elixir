defmodule SWAPIWeb.PersonControllerTest do
  use SWAPIWeb.ConnCase

  import SWAPI.PeopleFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "returns empty list when there are no people", %{conn: conn} do
      conn = get(conn, ~p"/api/people")

      assert json_response(conn, 200) == %{
               "next" => nil,
               "previous" => nil,
               "results" => [],
               "count" => 0
             }
    end

    test "returns all people", %{conn: conn} do
      for _ <- 1..3 do
        person_fixture()
      end

      conn = get(conn, ~p"/api/people")

      assert %{
               "next" => _,
               "previous" => _,
               "results" => [_, _, _],
               "count" => 3
             } = json_response(conn, 200)
    end

    test "returns matched people when searching", %{conn: conn} do
      for i <- 1..3 do
        person_fixture(%{
          name: "Person #{i}"
        })
      end

      conn = get(conn, ~p"/api/people?search=\"Person 1\"")

      assert %{
               "next" => nil,
               "previous" => nil,
               "results" => [%{"id" => 1}],
               "count" => 1
             } = json_response(conn, 200)
    end
  end

  describe "show" do
    setup [:create_person]

    test "returns a single person", %{conn: conn, person: person} do
      conn = get(conn, ~p"/api/people/1")
      result = json_response(conn, 200)

      assert String.ends_with?(result["url"], "/api/people/1")
      assert result["name"] == person.name
    end
  end

  defp create_person(_) do
    person = person_fixture()
    %{person: person}
  end
end
