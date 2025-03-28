defmodule SWAPIWeb.GraphQL.Types.Starship do
  @moduledoc """
  GraphQL schema for starships
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers
  import SWAPIWeb.GraphQL.Util

  @desc "The Starship type represents a single transport craft that has hyperdrive capability."
  object :starship do
    @desc "A unique ID for this starship."
    field :id, :id

    @desc "The name of this starship. The common name, such as \"Death Star\"."
    field :name, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The model or official name of this starship. Such as \"T-65 X-wing\" or \"DS-1 Orbital Battle Station\"."
    field :model, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The class of this starship, such as \"Starfighter\" or \"Deep Space Mobile Battlestation\""
    field :starship_class, :string

    @desc "The manufacturer of this starship. Comma separated if more than one."
    field :manufacturer, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The cost of this starship new, in galactic credits."
    field :cost_in_credits, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The length of this starship in meters."
    field :length, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The number of personnel needed to run or pilot this starship."
    field :crew, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The number of non-essential people this starship can transport."
    field :passengers, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The maximum speed of this starship in the atmosphere. \"N/A\" if this starship is incapable of atmospheric flight."
    field :max_atmosphering_speed, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The class of this starships hyperdrive."
    field :hyperdrive_rating, :string

    @desc "The Maximum number of Megalights this starship can travel in a standard hour. A \"Megalight\" is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth."
    field :mglt, :string

    @desc "The maximum number of kilograms that this starship can transport."
    field :cargo_capacity, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "The maximum length of time that this starship can provide consumables for its entire crew without having to resupply."
    field :consumables, :string do
      resolve(dataloader(SWAPI.Dataloader, :transport, callback: &transport_field_callback/4))
    end

    @desc "A list of films that this starship has appeared in."
    field :films, list_of(:film) do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "A list of people that this starship has been piloted by."
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
