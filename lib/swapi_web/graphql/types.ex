defmodule SWAPIWeb.GraphQL.Types do
  use Absinthe.Schema.Notation

  import_types(Absinthe.Type.Custom)

  import_types(SWAPIWeb.GraphQL.Types.Film)
  import_types(SWAPIWeb.GraphQL.Types.Person)
  import_types(SWAPIWeb.GraphQL.Types.Planet)
  import_types(SWAPIWeb.GraphQL.Types.Species)
  import_types(SWAPIWeb.GraphQL.Types.Starship)
end
