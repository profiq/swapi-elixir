defmodule SWAPI.PlanetsTest do
  use SWAPI.DataCase

  alias SWAPI.Planets

  describe "planets" do
    alias SWAPI.Schemas.Planet

    import SWAPI.PlanetsFixtures

    @invalid_attrs %{name: nil, diameter: nil, rotation_period: nil, orbital_period: nil, gravity: nil, population: nil, climate: nil, terrain: nil, surface_water: nil}

    test "list_planets/0 returns all planets" do
      planet = planet_fixture()
      assert Planets.list_planets() == [planet]
    end

    test "get_planet!/1 returns the planet with given id" do
      planet = planet_fixture()
      assert Planets.get_planet!(planet.id) == planet
    end

    test "create_planet/1 with valid data creates a planet" do
      valid_attrs = %{name: "some name", diameter: "some diameter", rotation_period: "some rotation_period", orbital_period: "some orbital_period", gravity: "some gravity", population: "some population", climate: "some climate", terrain: "some terrain", surface_water: "some surface_water"}

      assert {:ok, %Planet{} = planet} = Planets.create_planet(valid_attrs)
      assert planet.name == "some name"
      assert planet.diameter == "some diameter"
      assert planet.rotation_period == "some rotation_period"
      assert planet.orbital_period == "some orbital_period"
      assert planet.gravity == "some gravity"
      assert planet.population == "some population"
      assert planet.climate == "some climate"
      assert planet.terrain == "some terrain"
      assert planet.surface_water == "some surface_water"
    end

    test "create_planet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Planets.create_planet(@invalid_attrs)
    end

    test "update_planet/2 with valid data updates the planet" do
      planet = planet_fixture()
      update_attrs = %{name: "some updated name", diameter: "some updated diameter", rotation_period: "some updated rotation_period", orbital_period: "some updated orbital_period", gravity: "some updated gravity", population: "some updated population", climate: "some updated climate", terrain: "some updated terrain", surface_water: "some updated surface_water"}

      assert {:ok, %Planet{} = planet} = Planets.update_planet(planet, update_attrs)
      assert planet.name == "some updated name"
      assert planet.diameter == "some updated diameter"
      assert planet.rotation_period == "some updated rotation_period"
      assert planet.orbital_period == "some updated orbital_period"
      assert planet.gravity == "some updated gravity"
      assert planet.population == "some updated population"
      assert planet.climate == "some updated climate"
      assert planet.terrain == "some updated terrain"
      assert planet.surface_water == "some updated surface_water"
    end

    test "update_planet/2 with invalid data returns error changeset" do
      planet = planet_fixture()
      assert {:error, %Ecto.Changeset{}} = Planets.update_planet(planet, @invalid_attrs)
      assert planet == Planets.get_planet!(planet.id)
    end

    test "delete_planet/1 deletes the planet" do
      planet = planet_fixture()
      assert {:ok, %Planet{}} = Planets.delete_planet(planet)
      assert_raise Ecto.NoResultsError, fn -> Planets.get_planet!(planet.id) end
    end

    test "change_planet/1 returns a planet changeset" do
      planet = planet_fixture()
      assert %Ecto.Changeset{} = Planets.change_planet(planet)
    end
  end
end
