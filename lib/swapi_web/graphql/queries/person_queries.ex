defmodule SWAPIWeb.GraphQL.Queries.PersonQueries do
  use Absinthe.Schema.Notation

  alias SWAPIWeb.GraphQL.Resolvers.PersonResolver

  object :person_queries do
    @desc "Get all people."
    field :all_people, list_of(:person) do
      resolve(&PersonResolver.all/2)
    end

    @desc "Get a person by ID."
    field :person, :person do
      @desc "The ID of the person."
      arg(:id, non_null(:id))

      resolve(&PersonResolver.one/2)
    end

    @desc "Search people by name."
    field :search_people, list_of(:person) do
      @desc "A list of search terms. If multiple search terms are used then objects will be returned in the list only if all the provided terms are matched."
      arg(:search_terms, non_null(list_of(non_null(:string))))

      resolve(&PersonResolver.search/2)
    end
  end
end
