defmodule SWAPI.SpeciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SWAPI.Species` context.
  """

  @doc """
  Generate a species.
  """
  def species_fixture(attrs \\ %{}) do
    {:ok, species} =
      attrs
      |> Enum.into(%{
        name: "some name",
        classification: "some classification",
        designation: "some designation",
        average_height: "some average_height",
        average_lifespan: "some average_lifespan",
        eye_colors: "some eye_colors",
        hair_colors: "some hair_colors",
        skin_colors: "some skin_colors",
        language: "some language",
        homeworld: nil,
        people: [],
        films: []
      })
      |> SWAPI.Species.create_species()

    species
  end
end
