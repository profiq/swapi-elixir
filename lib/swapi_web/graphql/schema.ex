defmodule SWAPIWeb.GraphQL.Schema do
  use Absinthe.Schema

  import_types(SWAPIWeb.GraphQL.Types)
  import_types(SWAPIWeb.GraphQL.Queries)

  query do
    import_fields(:queries)
  end
end
