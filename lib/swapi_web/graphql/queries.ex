defmodule SWAPIWeb.GraphQL.Queries do
  use Absinthe.Schema.Notation

  import_types(SWAPIWeb.GraphQL.Queries.FilmQueries)

  object :queries do
    import_fields(:film_queries)
  end
end
