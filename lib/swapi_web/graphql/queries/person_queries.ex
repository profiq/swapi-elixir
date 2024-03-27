defmodule SWAPIWeb.GraphQL.Queries.PersonQueries do
  use Absinthe.Schema.Notation

  object :person_queries do
    @desc "Get all people."
    field :all_people, list_of(:person) do
      resolve(&SWAPIWeb.GraphQL.Resolvers.PersonResolver.all/2)
    end

    @desc "Get a person by ID."
    field :person, :person do
      @desc "The ID of the person."
      arg(:id, non_null(:id))

      resolve(&SWAPIWeb.GraphQL.Resolvers.PersonResolver.one/2)
    end
  end
end
