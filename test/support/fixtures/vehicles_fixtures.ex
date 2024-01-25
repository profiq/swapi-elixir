defmodule SWAPI.VehiclesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SWAPI.Vehicles` context.
  """

  @doc """
  Generate a vehicle.
  """
  def vehicle_fixture(attrs \\ %{}) do
    {:ok, vehicle} =
      attrs
      |> Enum.into(%{
        vehicle_class: "some vehicle_class",
        films: [],
        pilots: []
      })
      |> Map.put(
        :transport,
        attrs
        |> Map.get(:transport, %{})
        |> Enum.into(%{
          name: "some name",
          model: "some model",
          manufacturer: "some manufacturer",
          length: "some length",
          cost_in_credits: "some cost_in_credits",
          crew: "some crew",
          passengers: "some passengers",
          max_atmosphering_speed: "some max_atmosphering_speed",
          cargo_capacity: "some cargo_capacity",
          consumables: "some consumables"
        })
      )
      |> SWAPI.Vehicles.create_vehicle()

    vehicle
  end
end
