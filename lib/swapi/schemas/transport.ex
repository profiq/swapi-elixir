defmodule SWAPI.Schemas.Transport do
  @moduledoc """
  Transport schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [
    :name,
    :model,
    :manufacturer,
    :length,
    :cost_in_credits,
    :crew,
    :passengers,
    :max_atmosphering_speed,
    :cargo_capacity,
    :consumables
  ]
  @optional_fields [:id, :created, :edited]

  schema "transport" do
    field :name, :string
    field :model, :string
    field :manufacturer, :string
    field :length, :string
    field :cost_in_credits, :string
    field :crew, :string
    field :passengers, :string
    field :max_atmosphering_speed, :string
    field :cargo_capacity, :string
    field :consumables, :string

    timestamps(type: :utc_datetime, inserted_at: :created, updated_at: :edited)
  end

  @doc false
  def changeset(transport, attrs) do
    transport
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:id)
  end
end
