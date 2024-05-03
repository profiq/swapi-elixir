defmodule SWAPIWeb.GraphQL.Queries.SpeciesQueries do
  use Absinthe.Schema.Notation

  object :species_queries do
    @desc "Get all species."
    field :all_species, list_of(:species) do
      resolve(&SWAPIWeb.GraphQL.Resolvers.SpeciesResolver.all/2)
    end

    @desc "Get a species by ID."
    field :species, :species do
      @desc "The ID of the species."
      arg(:id, non_null(:id))

      resolve(&SWAPIWeb.GraphQL.Resolvers.SpeciesResolver.one/2)
    end

    @desc "Search species by name."
    field :search_species, list_of(:species) do
      @desc "A list of search terms. If multiple search terms are used then objects will be returned in the list only if all the provided terms are matched."
      arg(:search_terms, non_null(list_of(non_null(:string))))

      resolve(&SWAPIWeb.GraphQL.Resolvers.SpeciesResolver.search/2)
    end
  end
end
