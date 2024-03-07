defmodule SWAPIWeb.StarshipJSONTest do
  use SWAPI.DataCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.StarshipsFixtures
  import SWAPI.PeopleFixtures

  alias SWAPI.Schemas.Starship
  alias SWAPIWeb.StarshipJSON

  describe "show" do
    setup do
      starship =
        starship_fixture()
        |> Starship.changeset(%{})
        |> put_assoc(:films, [film_fixture()])
        |> put_assoc(:pilots, [person_fixture()])
        |> Repo.update!()

      {:ok, %{starship: starship}}
    end

    test "renders an item", %{starship: starship} do
      assert %{
               id: id,
               name: name,
               model: model,
               starship_class: starship_class,
               manufacturer: manufacturer,
               cost_in_credits: cost_in_credits,
               length: length,
               crew: crew,
               passengers: passengers,
               max_atmosphering_speed: max_atmosphering_speed,
               hyperdrive_rating: hyperdrive_rating,
               MGLT: mglt,
               cargo_capacity: cargo_capacity,
               consumables: consumables,
               films: [film_url],
               pilots: [pilot_url],
               url: url,
               created: created,
               edited: edited
             } = StarshipJSON.show(%{starship: starship})

      assert id == starship.id
      assert name == starship.transport.name
      assert model == starship.transport.model
      assert starship_class == starship.starship_class
      assert manufacturer == starship.transport.manufacturer
      assert cost_in_credits == starship.transport.cost_in_credits
      assert length == starship.transport.length
      assert crew == starship.transport.crew
      assert passengers == starship.transport.passengers
      assert max_atmosphering_speed == starship.transport.max_atmosphering_speed
      assert hyperdrive_rating == starship.hyperdrive_rating
      assert mglt == starship.mglt
      assert cargo_capacity == starship.transport.cargo_capacity
      assert consumables == starship.transport.consumables
      assert created == starship.transport.created
      assert edited == starship.transport.edited

      assert String.ends_with?(url, "/api/starships/#{starship.id}")
      assert String.ends_with?(film_url, "/api/films/#{List.first(starship.films).id}")
      assert String.ends_with?(pilot_url, "/api/people/#{List.first(starship.pilots).id}")
    end
  end

  describe "index" do
    setup do
      starships = for _ <- 1..10, do: starship_fixture()
      meta = %{count: length(starships), next: nil, previous: nil}
      conn = %Plug.Conn{request_path: "/api/starships", query_params: %{"page" => 1}}

      {:ok, %{starships: starships, meta: meta, conn: conn}}
    end

    test "renders a list of items", %{starships: starships, meta: meta, conn: conn} do
      assert %{
               count: count,
               next: nil,
               previous: nil,
               results: results
             } = StarshipJSON.index(%{starships: starships, meta: meta, conn: conn})

      assert count == meta.count
      assert is_list(results)
      assert length(results) == length(starships)
    end

    test "puts a link to next page if there is one", %{
      starships: starships,
      meta: meta,
      conn: conn
    } do
      meta = %{meta | next: {:page, 2}}

      assert %{
               count: _count,
               next: next_url,
               previous: nil,
               results: _results
             } = StarshipJSON.index(%{starships: starships, meta: meta, conn: conn})

      assert String.ends_with?(next_url, "/api/starships?page=2")
    end

    test "puts a link to previous page if there is one", %{
      starships: starships,
      meta: meta,
      conn: conn
    } do
      meta = %{meta | previous: {:page, 2}}

      assert %{
               count: _count,
               next: nil,
               previous: previous_url,
               results: _results
             } = StarshipJSON.index(%{starships: starships, meta: meta, conn: conn})

      assert String.ends_with?(previous_url, "/api/starships?page=2")
    end
  end
end
