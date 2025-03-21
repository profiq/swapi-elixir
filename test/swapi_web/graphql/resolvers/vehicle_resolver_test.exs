defmodule SWAPIWeb.GraphQL.Resolvers.VehicleResolverTest do
  use SWAPI.DataCase

  alias SWAPIWeb.GraphQL.Resolvers.VehicleResolver
  import SWAPI.VehiclesFixtures

  describe "all/2" do
    test "returns all vehicles" do
      %{id: vehicle_id} = vehicle_fixture()
      assert {:ok, [%{id: ^vehicle_id}]} = VehicleResolver.all(%{}, %{})
    end

    test "returns empty list when no vehicles exist" do
      assert {:ok, []} = VehicleResolver.all(%{}, %{})
    end
  end

  describe "one/2" do
    test "returns vehicle when it exists" do
      %{id: vehicle_id} = vehicle_fixture()
      assert {:ok, %{id: ^vehicle_id}} = VehicleResolver.one(%{id: vehicle_id}, %{})
    end

    test "returns error when vehicle doesn't exist" do
      assert {:error, "Vehicle not found"} = VehicleResolver.one(%{id: 0}, %{})
    end
  end

  describe "search/2" do
    test "returns matching vehicles" do
      %{id: vehicle_id} = vehicle_fixture(%{transport: %{name: "AT-AT"}})
      vehicle_fixture(%{name: "Snowspeeder"})

      assert {:ok, [%{id: ^vehicle_id}]} = VehicleResolver.search(%{search_terms: ["AT-AT"]}, %{})
    end

    test "returns empty list when no matches found" do
      vehicle_fixture(%{transport: %{name: "AT-AT"}})

      assert {:ok, []} = VehicleResolver.search(%{search_terms: ["Non-existent"]}, %{})
    end
  end
end
