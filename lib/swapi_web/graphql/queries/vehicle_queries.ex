defmodule SWAPIWeb.GraphQL.Queries.VehicleQueries do
  use Absinthe.Schema.Notation

  object :vehicle_queries do
    @desc "Get all vehicles."
    field :all_vehicles, list_of(:vehicle) do
      resolve(&SWAPIWeb.GraphQL.Resolvers.VehicleResolver.all/2)
    end

    @desc "Get a vehicle by ID."
    field :vehicle, :vehicle do
      @desc "The ID of the vehicle."
      arg(:id, non_null(:id))

      resolve(&SWAPIWeb.GraphQL.Resolvers.VehicleResolver.one/2)
    end
  end
end
