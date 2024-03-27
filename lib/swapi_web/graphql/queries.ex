defmodule SWAPIWeb.GraphQL.Queries do
  use Absinthe.Schema.Notation

  import_types(SWAPIWeb.GraphQL.Queries.FilmQueries)
  import_types(SWAPIWeb.GraphQL.Queries.PersonQueries)
  import_types(SWAPIWeb.GraphQL.Queries.PlanetQueries)
  import_types(SWAPIWeb.GraphQL.Queries.SpeciesQueries)
  import_types(SWAPIWeb.GraphQL.Queries.StarshipQueries)

  object :queries do
    import_fields(:film_queries)
    import_fields(:person_queries)
    import_fields(:planet_queries)
    import_fields(:species_queries)
    import_fields(:starship_queries)
  end
end
