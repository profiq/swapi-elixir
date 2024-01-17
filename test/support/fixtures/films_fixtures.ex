defmodule SWAPI.FilmsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SWAPI.Films` context.
  """

  @doc """
  Generate a film.
  """
  def film_fixture(attrs \\ %{}) do
    {:ok, film} =
      attrs
      |> Enum.into(%{
        title: "some title",
        episode_id: 42,
        opening_crawl: "some opening_crawl",
        director: "some director",
        producer: "some producer",
        release_date: ~D[2023-11-28],
        species: [],
        starships: [],
        vehicles: [],
        characters: [],
        planets: []
      })
      |> SWAPI.Films.create_film()

    film
  end
end
