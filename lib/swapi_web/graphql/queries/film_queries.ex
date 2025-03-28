defmodule SWAPIWeb.GraphQL.Queries.FilmQueries do
  @moduledoc """
  GraphQL queries for films
  """

  use Absinthe.Schema.Notation

  alias SWAPIWeb.GraphQL.Resolvers.FilmResolver

  object :film_queries do
    @desc "Get all films."
    field :all_films, list_of(:film) do
      resolve(&FilmResolver.all/2)
    end

    @desc "Get a film by ID."
    field :film, :film do
      @desc "The ID of the film."
      arg(:id, non_null(:id))

      resolve(&FilmResolver.one/2)
    end

    @desc "Search films by title."
    field :search_films, list_of(:film) do
      @desc "A list of search terms. If multiple search terms are used then objects will be returned in the list only if all the provided terms are matched."
      arg(:search_terms, non_null(list_of(non_null(:string))))

      resolve(&FilmResolver.search/2)
    end
  end
end
