defmodule SWAPIWeb.GraphQL.Queries.VehicleQueries do
  use Absinthe.Schema.Notation

  alias SWAPIWeb.GraphQL.Resolvers.VehicleResolver

  object :vehicle_queries do
    @desc "Get all vehicles."
    field :all_vehicles, list_of(:vehicle) do
      resolve(&VehicleResolver.all/2)
    end

    @desc "Get a vehicle by ID."
    field :vehicle, :vehicle do
      @desc "The ID of the vehicle."
      arg(:id, non_null(:id))

      resolve(&VehicleResolver.one/2)
    end

    @desc "Search vehicles by name or model."
    field :search_vehicles, list_of(:vehicle) do
      @desc "A list of search terms. If multiple search terms are used then objects will be returned in the list only if all the provided terms are matched."
      arg(:search_terms, non_null(list_of(non_null(:string))))

      resolve(&VehicleResolver.search/2)
    end
  end
end
