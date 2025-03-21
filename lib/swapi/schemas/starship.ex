defmodule SWAPI.Schemas.Starship do
  @moduledoc """
  Starship schema
  """

  use TypedEctoSchema
  import Ecto.Changeset

  alias SWAPI.Schemas.Film
  alias SWAPI.Schemas.Person
  alias SWAPI.Schemas.Transport

  @required_fields [:starship_class, :hyperdrive_rating, :mglt]
  @optional_fields [:id]

  @primary_key false

  typed_schema "starships" do
    belongs_to :transport, Transport, foreign_key: :id, primary_key: true, on_replace: :update

    field :starship_class, :string
    field :hyperdrive_rating, :string
    field :mglt, :string

    many_to_many :films, Film, join_through: "film_starships"
    many_to_many :pilots, Person, join_through: "starship_pilots"
  end

  @doc false
  def changeset(starship, attrs) do
    starship
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:transport)
    |> cast_assoc(:films)
    |> cast_assoc(:pilots)
    |> foreign_key_constraint(:id)
  end
end
