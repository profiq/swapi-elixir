defmodule SWAPIWeb.WookieeEncoderTest do
  use SWAPIWeb.ConnCase, async: true

  import SWAPI.PlanetsFixtures

  alias SWAPIWeb.WookieeEncoder

  describe "translate_to_wookie/1" do
    test "converts lowercase letters" do
      assert "aoacwo rqhuahoaor rhrcooohwh wwook shhuscakc oohoworc aoacwo anraufro waoorr" =
               WookieeEncoder.translate_to_wookiee("the quick brown fox jumps over the lazy dog")
    end

    test "leaves JSON special characters alone" do
      test_string = "\\{}\"\'[]:"
      assert ^test_string = WookieeEncoder.translate_to_wookiee(test_string)
    end

    test "leaves other non-lowercase characters alone" do
      assert "Twocao. 12345" = WookieeEncoder.translate_to_wookiee("Test. 12345")
    end
  end

  describe "call/2" do
    setup do
      %{id: planet_id} =
        planet_fixture(%{
          name: "Tatooine"
        })

      {:ok, %{planet_id: planet_id}}
    end

    test "converts JSON to wookiee if the format is wookiee", %{conn: conn, planet_id: planet_id} do
      conn = get(conn, ~p"/api/planets/#{planet_id}", format: "wookiee")
      assert %{"whrascwo" => "Traaoooooahwhwo"} = json_response(conn, 200)
    end

    test "does not modify the response if the format is not specified", %{
      conn: conn,
      planet_id: planet_id
    } do
      conn = get(conn, ~p"/api/planets/#{planet_id}")
      assert %{"name" => "Tatooine"} = json_response(conn, 200)
    end

    test "does not modify the response if the format is json", %{conn: conn, planet_id: planet_id} do
      conn = get(conn, ~p"/api/planets/#{planet_id}", format: "json")
      assert %{"name" => "Tatooine"} = json_response(conn, 200)
    end

    test "does not modify the response if the request fails", %{conn: conn} do
      conn = get(conn, ~p"/api/planets/123456789", format: "wookiee")
      assert %{"detail" => "Not Found"} = json_response(conn, 404)
    end
  end
end
