defmodule SWAPI.Schemas.Species do
  use Ecto.Schema
  import Ecto.Changeset

  alias SWAPI.Schemas.Film
  alias SWAPI.Schemas.Person
  alias SWAPI.Schemas.Planet

  @required_fields [:name, :classification, :designation, :average_height, :average_lifespan, :eye_colors, :hair_colors, :skin_colors, :language]
  @optional_fields [:id, :homeworld_id, :created, :edited]

  schema "species" do
    field :name, :string
    field :classification, :string
    field :designation, :string
    field :average_height, :string
    field :average_lifespan, :string
    field :eye_colors, :string
    field :hair_colors, :string
    field :skin_colors, :string
    field :language, :string

    belongs_to :homeworld, Planet

    many_to_many :people, Person, join_through: "people_species"
    many_to_many :films, Film, join_through: "film_species"

    timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
  end

  @doc false
  def changeset(species, attrs) do
    species
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:homeworld)
    |> cast_assoc(:people)
    |> cast_assoc(:films)
    |> unique_constraint(:id)
  end
end
