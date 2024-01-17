defmodule SWAPI.PlanetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SWAPI.Planets` context.
  """

  @doc """
  Generate a planet.
  """
  def planet_fixture(attrs \\ %{}) do
    {:ok, planet} =
      attrs
      |> Enum.into(%{
        name: "some name",
        diameter: "some diameter",
        rotation_period: "some rotation_period",
        orbital_period: "some orbital_period",
        gravity: "some gravity",
        population: "some population",
        climate: "some climate",
        terrain: "some terrain",
        surface_water: "some surface_water",
        residents: [],
        films: []
      })
      |> SWAPI.Planets.create_planet()

    planet
  end
end
