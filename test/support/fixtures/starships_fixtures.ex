defmodule SWAPI.StarshipsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SWAPI.Starships` context.
  """

  @doc """
  Generate a starship.
  """
  def starship_fixture(attrs \\ %{}) do
    {:ok, starship} =
      attrs
      |> Enum.into(%{
        starship_class: "some starship_class",
        hyperdrive_rating: "some hyperdrive_rating",
        mglt: "some mglt",
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
      |> SWAPI.Starships.create_starship()

    starship
  end
end
