defmodule SWAPIWeb.GraphQL.Resolvers.StarshipResolverTest do
  use SWAPI.DataCase

  alias SWAPIWeb.GraphQL.Resolvers.StarshipResolver
  import SWAPI.StarshipsFixtures

  describe "all/2" do
    test "returns all starships" do
      %{id: starship_id} = starship_fixture()
      assert {:ok, [%{id: ^starship_id}]} = StarshipResolver.all(%{}, %{})
    end

    test "returns empty list when no starships exist" do
      assert {:ok, []} = StarshipResolver.all(%{}, %{})
    end
  end

  describe "one/2" do
    test "returns starship when it exists" do
      %{id: starship_id} = starship_fixture()
      assert {:ok, %{id: ^starship_id}} = StarshipResolver.one(%{id: starship_id}, %{})
    end

    test "returns error when starship doesn't exist" do
      assert {:error, "Starship not found"} = StarshipResolver.one(%{id: 0}, %{})
    end
  end

  describe "search/2" do
    test "returns matching starships" do
      %{id: starship_id} = starship_fixture(%{transport: %{name: "X-wing"}})
      starship_fixture(%{transport: %{name: "TIE Fighter"}})

      assert {:ok, [%{id: ^starship_id}]} =
               StarshipResolver.search(%{search_terms: ["X-wing"]}, %{})
    end

    test "returns empty list when no matches found" do
      starship_fixture(%{transport: %{name: "X-wing"}})

      assert {:ok, []} = StarshipResolver.search(%{search_terms: ["Non-existent"]}, %{})
    end
  end
end
