defmodule SWAPI.Schemas.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  alias SWAPI.Schemas.Film
  alias SWAPI.Schemas.Person
  alias SWAPI.Schemas.Transport

  @required_fields [:vehicle_class]
  @optional_fields [:id]

  @primary_key false

  schema "vehicles" do
    belongs_to :transport, Transport, foreign_key: :id, primary_key: true

    field :vehicle_class, :string

    many_to_many :films, Film, join_through: "film_vehicles"
    many_to_many :pilots, Person, join_through: "vehicle_pilots"
  end

  @doc false
  def changeset(vehicle, params \\ %{}) do
    vehicle
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:transport)
    |> foreign_key_constraint(:id)
  end
end
