defmodule SWAPIWeb.GraphQL.Types do
  use Absinthe.Schema.Notation

  import_types(Absinthe.Type.Custom)

  import_types(SWAPIWeb.GraphQL.Types.Film)
end
