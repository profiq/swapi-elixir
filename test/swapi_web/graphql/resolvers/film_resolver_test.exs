defmodule SWAPIWeb.GraphQL.Resolvers.FilmResolverTest do
  use SWAPI.DataCase

  alias SWAPIWeb.GraphQL.Resolvers.FilmResolver
  import SWAPI.FilmsFixtures

  describe "all/2" do
    test "returns all films" do
      %{id: film_id} = film_fixture()
      assert {:ok, [%{id: ^film_id}]} = FilmResolver.all(%{}, %{})
    end

    test "returns empty list when no films exist" do
      assert {:ok, []} = FilmResolver.all(%{}, %{})
    end
  end

  describe "one/2" do
    test "returns film when it exists" do
      %{id: film_id} = film_fixture()
      assert {:ok, %{id: ^film_id}} = FilmResolver.one(%{id: film_id}, %{})
    end

    test "returns error when film doesn't exist" do
      assert {:error, "Film not found"} = FilmResolver.one(%{id: 0}, %{})
    end
  end

  describe "search/2" do
    test "returns matching films" do
      %{id: film_id} = film_fixture(%{title: "A New Hope"})
      film_fixture(%{title: "Empire Strikes Back"})

      assert {:ok, [%{id: ^film_id}]} = FilmResolver.search(%{search_terms: ["Hope"]}, %{})
    end

    test "returns empty list when no matches found" do
      film_fixture(%{title: "A New Hope"})

      assert {:ok, []} = FilmResolver.search(%{search_terms: ["Non-existent"]}, %{})
    end
  end
end
