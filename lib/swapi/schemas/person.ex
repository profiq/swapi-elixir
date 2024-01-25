defmodule SWAPI.Schemas.Person do
  @moduledoc """
  Person schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SWAPI.Schemas.Film
  alias SWAPI.Schemas.Planet
  alias SWAPI.Schemas.Species
  alias SWAPI.Schemas.Starship
  alias SWAPI.Schemas.Vehicle

  @required_fields [
    :name,
    :birth_year,
    :eye_color,
    :gender,
    :hair_color,
    :height,
    :mass,
    :skin_color
  ]
  @optional_fields [:id, :homeworld_id, :created, :edited]

  schema "people" do
    field :name, :string
    field :birth_year, :string
    field :eye_color, :string
    field :gender, :string
    field :hair_color, :string
    field :height, :string
    field :mass, :string
    field :skin_color, :string

    belongs_to :homeworld, Planet

    many_to_many :films, Film, join_through: "film_characters"
    many_to_many :species, Species, join_through: "people_species"
    many_to_many :starships, Starship, join_through: "starship_pilots"
    many_to_many :vehicles, Vehicle, join_through: "vehicle_pilots"

    timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:homeworld)
    |> cast_assoc(:films)
    |> cast_assoc(:species)
    |> cast_assoc(:starships)
    |> cast_assoc(:vehicles)
    |> unique_constraint(:id)
  end
end
