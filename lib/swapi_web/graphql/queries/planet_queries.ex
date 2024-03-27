defmodule SWAPIWeb.GraphQL.Queries.PlanetQueries do
  use Absinthe.Schema.Notation

  object :planet_queries do
    @desc "Get all planets."
    field :all_planets, list_of(:planet) do
      resolve(&SWAPIWeb.GraphQL.Resolvers.PlanetResolver.all/2)
    end

    @desc "Get a planet by ID."
    field :planet, :planet do
      @desc "The ID of the planet."
      arg(:id, non_null(:id))

      resolve(&SWAPIWeb.GraphQL.Resolvers.PlanetResolver.one/2)
    end
  end
end
