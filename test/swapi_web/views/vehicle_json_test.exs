defmodule SWAPIWeb.VehicleJSONTest do
  use SWAPI.DataCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.VehiclesFixtures
  import SWAPI.PeopleFixtures

  alias SWAPI.Schemas.Vehicle
  alias SWAPIWeb.VehicleJSON

  describe "show" do
    setup do
      vehicle =
        vehicle_fixture()
        |> Vehicle.changeset(%{})
        |> put_assoc(:films, [film_fixture()])
        |> put_assoc(:pilots, [person_fixture()])
        |> Repo.update!()

      {:ok, %{vehicle: vehicle}}
    end

    test "renders an item", %{vehicle: vehicle} do
      assert %{
               id: id,
               name: name,
               model: model,
               vehicle_class: vehicle_class,
               manufacturer: manufacturer,
               cost_in_credits: cost_in_credits,
               length: length,
               crew: crew,
               passengers: passengers,
               max_atmosphering_speed: max_atmosphering_speed,
               cargo_capacity: cargo_capacity,
               consumables: consumables,
               films: [film_url],
               pilots: [pilot_url],
               url: url,
               created: created,
               edited: edited
             } = VehicleJSON.show(%{vehicle: vehicle})

      assert id == vehicle.id
      assert name == vehicle.transport.name
      assert model == vehicle.transport.model
      assert vehicle_class == vehicle.vehicle_class
      assert manufacturer == vehicle.transport.manufacturer
      assert cost_in_credits == vehicle.transport.cost_in_credits
      assert length == vehicle.transport.length
      assert crew == vehicle.transport.crew
      assert passengers == vehicle.transport.passengers
      assert max_atmosphering_speed == vehicle.transport.max_atmosphering_speed
      assert cargo_capacity == vehicle.transport.cargo_capacity
      assert consumables == vehicle.transport.consumables
      assert created == vehicle.transport.created
      assert edited == vehicle.transport.edited

      assert String.ends_with?(url, "/api/vehicles/#{vehicle.id}")
      assert String.ends_with?(film_url, "/api/films/#{List.first(vehicle.films).id}")
      assert String.ends_with?(pilot_url, "/api/people/#{List.first(vehicle.pilots).id}")
    end
  end

  describe "index" do
    setup do
      vehicles = for _ <- 1..10, do: vehicle_fixture()
      meta = %{count: length(vehicles), next: nil, previous: nil}
      conn = %Plug.Conn{request_path: "/api/vehicles", query_params: %{"page" => 1}}

      {:ok, %{vehicles: vehicles, meta: meta, conn: conn}}
    end

    test "renders a list of items", %{vehicles: vehicles, meta: meta, conn: conn} do
      assert %{
               count: count,
               next: nil,
               previous: nil,
               results: results
             } = VehicleJSON.index(%{vehicles: vehicles, meta: meta, conn: conn})

      assert count == meta.count
      assert is_list(results)
      assert length(results) == length(vehicles)
    end

    test "puts a link to next page if there is one", %{vehicles: vehicles, meta: meta, conn: conn} do
      meta = %{meta | next: {:page, 2}}

      assert %{
               count: _count,
               next: next_url,
               previous: nil,
               results: _results
             } = VehicleJSON.index(%{vehicles: vehicles, meta: meta, conn: conn})

      assert String.ends_with?(next_url, "/api/vehicles?page=2")
    end

    test "puts a link to previous page if there is one", %{
      vehicles: vehicles,
      meta: meta,
      conn: conn
    } do
      meta = %{meta | previous: {:page, 2}}

      assert %{
               count: _count,
               next: nil,
               previous: previous_url,
               results: _results
             } = VehicleJSON.index(%{vehicles: vehicles, meta: meta, conn: conn})

      assert String.ends_with?(previous_url, "/api/vehicles?page=2")
    end
  end
end
