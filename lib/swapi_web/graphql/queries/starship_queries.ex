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

    @desc "Search starships by name or model."
    field :search_starships, list_of(:starship) do
      @desc "A list of search terms. If multiple search terms are used then objects will be returned in the list only if all the provided terms are matched."
      arg(:search_terms, non_null(list_of(non_null(:string))))

      resolve(&SWAPIWeb.GraphQL.Resolvers.StarshipResolver.search/2)
    end
  end
end
