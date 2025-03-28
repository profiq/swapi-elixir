defmodule SWAPIWeb.GraphQL.Types.Vehicle do
  @moduledoc """
  GraphQL schema for vehicles
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers
  import SWAPIWeb.GraphQL.Util

  @desc "The Vehicle type represents a single transport craft that does not have hyperdrive capability."
  object :vehicle do
    @desc "A unique ID for this vehicle."
    field :id, :id

    @desc "The name of this vehicle. The common name, such as \"Sand Crawler\" or \"Speeder bike\"."
    field :name, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The model or official name of this vehicle. Such as \"All-Terrain Attack Transport\"."
    field :model, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The class of this vehicle, such as \"Wheeled\" or \"Repulsorcraft\"."
    field :vehicle_class, :string

    @desc "The manufacturer of this vehicle. Comma separated if more than one."
    field :manufacturer, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The length of this vehicle in meters."
    field :cost_in_credits, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The cost of this vehicle new, in Galactic Credits."
    field :length, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The number of personnel needed to run or pilot this vehicle."
    field :crew, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The number of non-essential people this vehicle can transport."
    field :passengers, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The maximum speed of this vehicle in the atmosphere."
    field :max_atmosphering_speed, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The maximum number of kilograms that this vehicle can transport."
    field :cargo_capacity, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The maximum length of time that this vehicle can provide consumables for its entire crew without having to resupply."
    field :consumables, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "A list of films that this vehicle has appeared in."
    field :films, list_of(:film) do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "A list of people that this vehicle has been piloted by."
    field :pilots, list_of(:person) do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "The time that this resource was created."
    field :created, :datetime do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The time that this resource was edited."
    field :edited, :datetime do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end
  end
end
