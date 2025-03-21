defmodule SWAPIWeb.GraphQL.Resolvers.PlanetResolverTest do
  use SWAPI.DataCase

  alias SWAPIWeb.GraphQL.Resolvers.PlanetResolver
  import SWAPI.PlanetsFixtures

  describe "all/2" do
    test "returns all planets" do
      %{id: planet_id} = planet_fixture()
      assert {:ok, [%{id: ^planet_id}]} = PlanetResolver.all(%{}, %{})
    end

    test "returns empty list when no planets exist" do
      assert {:ok, []} = PlanetResolver.all(%{}, %{})
    end
  end

  describe "one/2" do
    test "returns planet when it exists" do
      %{id: planet_id} = planet_fixture()
      assert {:ok, %{id: ^planet_id}} = PlanetResolver.one(%{id: planet_id}, %{})
    end

    test "returns error when planet doesn't exist" do
      assert {:error, "Planet not found"} = PlanetResolver.one(%{id: 0}, %{})
    end
  end

  describe "search/2" do
    test "returns matching planets" do
      %{id: planet_id} = planet_fixture(%{name: "Tatooine"})
      planet_fixture(%{name: "Alderaan"})

      assert {:ok, [%{id: ^planet_id}]} =
               PlanetResolver.search(%{search_terms: ["Tatooine"]}, %{})
    end

    test "returns empty list when no matches found" do
      planet_fixture(%{name: "Tatooine"})

      assert {:ok, []} = PlanetResolver.search(%{search_terms: ["Non-existent"]}, %{})
    end
  end
end
