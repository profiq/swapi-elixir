defmodule SWAPIWeb.GraphQL.Queries.StarshipQueries do
  use Absinthe.Schema.Notation

  object :starship_queries do
    @desc "Get all starships."
    field :all_starships, list_of(:starship) do
      resolve(&SWAPIWeb.GraphQL.Resolvers.StarshipResolver.all/2)
    end

    @desc "Get a starship by ID."
    field :starship, :starship do
      @desc "The ID of the starship."
      arg(:id, non_null(:id))

      resolve(&SWAPIWeb.GraphQL.Resolvers.StarshipResolver.one/2)
    end
  end
end
