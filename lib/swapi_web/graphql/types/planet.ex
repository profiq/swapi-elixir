defmodule SWAPIWeb.GraphQL.Types.Planet do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers

  @desc "The Planet type represents a large mass, planet or planetoid in the Star Wars Universe, at the time of 0 ABY."
  object :planet do
    @desc "A unique ID for this planet."
    field :id, :id

    @desc "The name of this planet."
    field :name, :string

    @desc "The diameter of this planet in kilometers."
    field :diameter, :string

    @desc "The number of standard hours it takes for this planet to complete a single rotation on its axis."
    field :rotation_period, :string

    @desc "The number of standard days it takes for this planet to complete a single orbit of its local star."
    field :orbital_period, :string

    @desc "A number denoting the gravity of this planet, where \"1\" is normal or 1 standard G. \"2\" is twice or 2 standard Gs. \"0.5\" is half or 0.5 standard Gs."
    field :gravity, :string

    @desc "The average population of sentient beings inhabiting this planet."
    field :population, :string

    @desc "The climate of this planet. Comma separated if diverse."
    field :climate, :string

    @desc "The terrain of this planet. Comma separated if diverse."
    field :terrain, :string

    @desc "The percentage of the planet surface that is naturally occurring water or bodies of water."
    field :surface_water, :string

    @desc "A list of people that live on this planet."
    field :residents, list_of(:person)

    @desc "A list of species that live on this planet."
    field :species, list_of(:species)

    @desc "A list of films that this planet has appeared in."
    field :films, list_of(:film)

    @desc "The time that this resource was created."
    field :created, :datetime

    @desc "The time that this resource was edited."
    field :edited, :datetime
  end
end
