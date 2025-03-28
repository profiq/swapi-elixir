defmodule SWAPIWeb.GraphQL.Types.Species do
  @moduledoc """
  GraphQL schema for species
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers

  @desc "The Species type represents a type of person or character within the Star Wars Universe."
  object :species do
    @desc "A unique ID for this species."
    field :id, :id

    @desc "The name of this species."
    field :name, :string

    @desc ~S(The classification of this species, such as "mammal" or "reptile".)
    field :classification, :string

    @desc "The designation of this species, such as \"sentient\"."
    field :designation, :string

    @desc "The average height of this species in centimeters."
    field :average_height, :string

    @desc "The average lifespan of this species in years."
    field :average_lifespan, :string

    @desc "A comma-separated string of common eye colors for this species, \"none\" if this species does not typically have eyes."
    field :eye_colors, :string

    @desc "A comma-separated string of common hair colors for this species, \"none\" if this species does not typically have hair."
    field :hair_colors, :string

    @desc "A comma-separated string of common skin colors for this species, \"none\" if this species does not typically have skin."
    field :skin_colors, :string

    @desc "The language commonly spoken by this species."
    field :language, :string

    @desc "The planet that this species originates from."
    field :homeworld, :planet do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "A list of people that are a part of this species."
    field :people, list_of(:person) do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "A list of films that this species has appeared in."
    field :films, list_of(:film) do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "The time that this resource was created."
    field :created, :datetime

    @desc "The time that this resource was edited."
    field :edited, :datetime
  end
end
