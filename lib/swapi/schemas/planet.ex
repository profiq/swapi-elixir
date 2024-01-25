defmodule SWAPI.Schemas.Planet do
  @moduledoc """
  Planet schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SWAPI.Schemas.Film
  alias SWAPI.Schemas.Person

  @required_fields [
    :name,
    :diameter,
    :rotation_period,
    :orbital_period,
    :gravity,
    :population,
    :climate,
    :terrain,
    :surface_water
  ]
  @optional_fields [:id, :created, :edited]

  schema "planets" do
    field :name, :string
    field :diameter, :string
    field :rotation_period, :string
    field :orbital_period, :string
    field :gravity, :string
    field :population, :string
    field :climate, :string
    field :terrain, :string
    field :surface_water, :string

    has_many :residents, Person, foreign_key: :homeworld_id

    many_to_many :films, Film, join_through: "film_planets"

    timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
  end

  @doc false
  def changeset(planet, attrs) do
    planet
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:residents)
    |> cast_assoc(:films)
    |> unique_constraint(:id)
  end
end
