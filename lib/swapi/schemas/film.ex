defmodule SWAPI.Schemas.Film do
  @moduledoc """
  Film schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias SWAPI.Schemas.Person
  alias SWAPI.Schemas.Planet
  alias SWAPI.Schemas.Species
  alias SWAPI.Schemas.Starship
  alias SWAPI.Schemas.Vehicle

  @required_fields [:title, :episode_id, :opening_crawl, :director, :producer, :release_date]
  @optional_fields [:id, :created, :edited]

  schema "films" do
    field :title, :string
    field :episode_id, :integer
    field :opening_crawl, :string
    field :director, :string
    field :producer, :string
    field :release_date, :date

    many_to_many :species, Species, join_through: "film_species"
    many_to_many :starships, Starship, join_through: "film_starships"
    many_to_many :vehicles, Vehicle, join_through: "film_vehicles"
    many_to_many :characters, Person, join_through: "film_characters"
    many_to_many :planets, Planet, join_through: "film_planets"

    timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
  end

  @doc false
  def changeset(film, attrs) do
    film
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:species)
    |> cast_assoc(:starships)
    |> cast_assoc(:vehicles)
    |> cast_assoc(:characters)
    |> cast_assoc(:planets)
    |> unique_constraint(:id)
  end
end
