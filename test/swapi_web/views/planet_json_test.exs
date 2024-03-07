defmodule SWAPIWeb.PlanetJSONTest do
  use SWAPI.DataCase

  import Ecto.Changeset

  import SWAPI.FilmsFixtures
  import SWAPI.PlanetsFixtures
  import SWAPI.PeopleFixtures

  alias SWAPI.Schemas.Planet
  alias SWAPIWeb.PlanetJSON

  describe "show" do
    setup do
      planet =
        planet_fixture()
        |> Planet.changeset(%{})
        |> put_assoc(:residents, [person_fixture()])
        |> put_assoc(:films, [film_fixture()])
        |> Repo.update!()

      {:ok, %{planet: planet}}
    end

    test "renders an item", %{planet: planet} do
      assert %{
               id: id,
               name: name,
               diameter: diameter,
               rotation_period: rotation_period,
               orbital_period: orbital_period,
               gravity: gravity,
               population: population,
               climate: climate,
               terrain: terrain,
               surface_water: surface_water,
               residents: [resident_url],
               films: [film_url],
               url: url,
               created: created,
               edited: edited
             } = PlanetJSON.show(%{planet: planet})

      assert id == planet.id
      assert name == planet.name
      assert diameter == planet.diameter
      assert rotation_period == planet.rotation_period
      assert orbital_period == planet.orbital_period
      assert gravity == planet.gravity
      assert population == planet.population
      assert climate == planet.climate
      assert terrain == planet.terrain
      assert surface_water == planet.surface_water
      assert created == planet.created
      assert edited == planet.edited

      assert String.ends_with?(url, "/api/planets/#{planet.id}")
      assert String.ends_with?(resident_url, "/api/people/#{List.first(planet.residents).id}")
      assert String.ends_with?(film_url, "/api/films/#{List.first(planet.films).id}")
    end
  end

  describe "index" do
    setup do
      planets = for _ <- 1..10, do: planet_fixture()
      meta = %{count: length(planets), next: nil, previous: nil}
      conn = %Plug.Conn{request_path: "/api/planets", query_params: %{"page" => 1}}

      {:ok, %{planets: planets, meta: meta, conn: conn}}
    end

    test "renders a list of items", %{planets: planets, meta: meta, conn: conn} do
      assert %{
               count: count,
               next: nil,
               previous: nil,
               results: results
             } = PlanetJSON.index(%{planets: planets, meta: meta, conn: conn})

      assert count == meta.count
      assert is_list(results)
      assert length(results) == length(planets)
    end

    test "puts a link to next page if there is one", %{planets: planets, meta: meta, conn: conn} do
      meta = %{meta | next: {:page, 2}}

      assert %{
               count: _count,
               next: next_url,
               previous: nil,
               results: _results
             } = PlanetJSON.index(%{planets: planets, meta: meta, conn: conn})

      assert String.ends_with?(next_url, "/api/planets?page=2")
    end

    test "puts a link to previous page if there is one", %{
      planets: planets,
      meta: meta,
      conn: conn
    } do
      meta = %{meta | previous: {:page, 2}}

      assert %{
               count: _count,
               next: nil,
               previous: previous_url,
               results: _results
             } = PlanetJSON.index(%{planets: planets, meta: meta, conn: conn})

      assert String.ends_with?(previous_url, "/api/planets?page=2")
    end
  end
end
