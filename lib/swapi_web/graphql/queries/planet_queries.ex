defmodule SWAPIWeb.GraphQL.Queries.PlanetQueries do
  @moduledoc """
  GraphQL queries for planets
  """

  use Absinthe.Schema.Notation

  alias SWAPIWeb.GraphQL.Resolvers.PlanetResolver

  object :planet_queries do
    @desc "Get all planets."
    field :all_planets, list_of(:planet) do
      resolve(&PlanetResolver.all/2)
    end

    @desc "Get a planet by ID."
    field :planet, :planet do
      @desc "The ID of the planet."
      arg(:id, non_null(:id))

      resolve(&PlanetResolver.one/2)
    end

    @desc "Search planets by name."
    field :search_planets, list_of(:planet) do
      @desc "A list of search terms. If multiple search terms are used then objects will be returned in the list only if all the provided terms are matched."
      arg(:search_terms, non_null(list_of(non_null(:string))))

      resolve(&PlanetResolver.search/2)
    end
  end
end
