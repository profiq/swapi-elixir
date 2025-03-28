defmodule SWAPIWeb.GraphQL.Resolvers.PersonResolverTest do
  use SWAPI.DataCase

  alias SWAPIWeb.GraphQL.Resolvers.PersonResolver
  import SWAPI.PeopleFixtures

  describe "all/2" do
    test "returns all people" do
      %{id: person_id} = person_fixture()
      assert {:ok, [%{id: ^person_id}]} = PersonResolver.all(%{}, %{})
    end

    test "returns empty list when no people exist" do
      assert {:ok, []} = PersonResolver.all(%{}, %{})
    end
  end

  describe "one/2" do
    test "returns person when they exist" do
      %{id: person_id} = person_fixture()
      assert {:ok, %{id: ^person_id}} = PersonResolver.one(%{id: person_id}, %{})
    end

    test "returns error when person doesn't exist" do
      assert {:error, "Person not found"} = PersonResolver.one(%{id: 0}, %{})
    end
  end

  describe "search/2" do
    test "returns matching people" do
      %{id: person_id} = person_fixture(%{name: "Luke Skywalker"})
      person_fixture(%{name: "Leia Organa"})

      assert {:ok, [%{id: ^person_id}]} = PersonResolver.search(%{search_terms: ["Luke"]}, %{})
    end

    test "returns empty list when no matches found" do
      person_fixture(%{name: "Luke Skywalker"})

      assert {:ok, []} = PersonResolver.search(%{search_terms: ["Non-existent"]}, %{})
    end
  end
end
