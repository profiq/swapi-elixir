defmodule SWAPIWeb.GraphQL.Types.Person do
  @moduledoc """
  GraphQL schema for people
  """

  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers

  @desc "The Person type represents an individual person or character within the Star Wars universe."
  object :person do
    @desc "A unique ID for this person."
    field :id, :id

    @desc "The name of this person."
    field :name, :string

    @desc "The birth year of the person, using the in-universe standard of **BBY** or **ABY** - Before the Battle of Yavin or After the Battle of Yavin. The Battle of Yavin is a battle that occurs at the end of Star Wars episode IV: A New Hope."
    field :birth_year, :string

    @desc "The eye color of this person. Will be \"unknown\" if not known or \"n/a\" if the person does not have an eye."
    field :eye_color, :string

    @desc "The gender of this person. Either \"Male\", \"Female\" or \"unknown\", \"n/a\" if the person does not have a gender."
    field :gender, :string

    @desc "The hair color of this person. Will be \"unknown\" if not known or \"n/a\" if the person does not have hair."
    field :hair_color, :string

    @desc "The height of the person in centimeters."
    field :height, :string

    @desc "The mass of the person in kilograms."
    field :mass, :string

    @desc "The skin color of this person."
    field :skin_color, :string

    @desc "The planet that this person was born on or inhabits."
    field :homeworld, :planet do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "A list of films that this person has been in."
    field :films, list_of(:film) do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "A list of species that this person belongs to."
    field :species, list_of(:species) do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "A list of starships that this person has piloted."
    field :starships, list_of(:starship) do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "A list of vehicles that this person has piloted."
    field :vehicles, list_of(:vehicle) do
      resolve(dataloader(SWAPI.Dataloader))
    end

    @desc "The time that this resource was created."
    field :created, :datetime

    @desc "The time that this resource was edited."
    field :edited, :datetime
  end
end
