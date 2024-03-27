defmodule SWAPIWeb.GraphQL.Queries.FilmQueries do
  use Absinthe.Schema.Notation

  object :film_queries do
    @desc "Get all films."
    field :all_films, list_of(:film) do
      resolve(&SWAPIWeb.GraphQL.Resolvers.FilmResolver.all/2)
    end

    @desc "Get a film by ID."
    field :film, :film do
      @desc "The ID of the film."
      arg(:id, non_null(:id))

      resolve(&SWAPIWeb.GraphQL.Resolvers.FilmResolver.one/2)
    end
  end
end
