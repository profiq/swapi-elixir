defmodule SWAPIWeb.GraphQL.Schema do
  @moduledoc """
  GraphQL schema
  """

  use Absinthe.Schema

  import_types(SWAPIWeb.GraphQL.Types)
  import_types(SWAPIWeb.GraphQL.Queries)

  query do
    import_fields(:queries)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(SWAPI.Dataloader, SWAPI.Dataloader.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
