defmodule SWAPIWeb.GraphQL.Resolvers.SpeciesResolverTest do
  use SWAPI.DataCase

  alias SWAPIWeb.GraphQL.Resolvers.SpeciesResolver
  import SWAPI.SpeciesFixtures

  describe "all/2" do
    test "returns all species" do
      %{id: species_id} = species_fixture()
      assert {:ok, [%{id: ^species_id}]} = SpeciesResolver.all(%{}, %{})
    end

    test "returns empty list when no species exist" do
      assert {:ok, []} = SpeciesResolver.all(%{}, %{})
    end
  end

  describe "one/2" do
    test "returns species when it exists" do
      %{id: species_id} = species_fixture()
      assert {:ok, %{id: ^species_id}} = SpeciesResolver.one(%{id: species_id}, %{})
    end

    test "returns error when species doesn't exist" do
      assert {:error, "Species not found"} = SpeciesResolver.one(%{id: 0}, %{})
    end
  end

  describe "search/2" do
    test "returns matching species" do
      %{id: species_id} = species_fixture(%{name: "Human"})
      species_fixture(%{name: "Wookiee"})

      assert {:ok, [%{id: ^species_id}]} = SpeciesResolver.search(%{search_terms: ["Human"]}, %{})
    end

    test "returns empty list when no matches found" do
      species_fixture(%{name: "Human"})

      assert {:ok, []} = SpeciesResolver.search(%{search_terms: ["Non-existent"]}, %{})
    end
  end
end
