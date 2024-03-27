defmodule SWAPIWeb.GraphQL.Types.Film do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers

  @desc "The Film type represents a single film."
  object :film do
    @desc "A unique ID for this film."
    field :id, :id

    @desc "The title of this film."
    field :title, :string

    @desc "The episode number of this film."
    field :episode_id, :integer

    @desc "The opening paragraphs at the beginning of this film."
    field :opening_crawl, :string

    @desc "The name of the director of this film."
    field :director, :string

    @desc "The name(s) of the producer(s) of this film. Comma separated."
    field :producer, :string

    @desc "The date of film release at original creator country."
    field :release_date, :date

    @desc "A list of species that are in this film."
    field :species, list_of(:species)

    @desc "A list of starships that are in this film."
    field :starships, list_of(:starship)

    @desc "A list of vehicles that are in this film."
    field :vehicles, list_of(:vehicle)

    @desc "A list of people that are in this film."
    field :characters, list_of(:person)

    @desc "A list of planets that are in this film."
    field :planets, list_of(:planet)

    @desc "The time that this resource was created."
    field :created, :datetime

    @desc "The time that this resource was edited."
    field :edited, :datetime
  end
end
