defmodule SWAPI.PeopleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SWAPI.People` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        name: "some name",
        birth_year: "some birth_year",
        eye_color: "some eye_color",
        gender: "some gender",
        hair_color: "some hair_color",
        height: "some height",
        mass: "some mass",
        skin_color: "some skin_color",
        homeworld: nil,
        films: [],
        species: [],
        starships: [],
        vehicles: []
      })
      |> SWAPI.People.create_person()

    person
  end
end
