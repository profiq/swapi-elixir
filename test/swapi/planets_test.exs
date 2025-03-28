defmodule SWAPI.PlanetsTest do
  use SWAPI.DataCase

  alias SWAPI.Planets

  describe "planets" do
    alias SWAPI.Schemas.Planet

    import SWAPI.PlanetsFixtures

    @invalid_attrs %{
      name: nil,
      diameter: nil,
      rotation_period: nil,
      orbital_period: nil,
      gravity: nil,
      population: nil,
      climate: nil,
      terrain: nil,
      surface_water: nil
    }

    test "list_planets/0 returns all planets" do
      planet = planet_fixture()
      assert [^planet] = Planets.list_planets() |> Enum.map(&Planets.preload_all/1)
    end

    test "list_planets/1 returns all planets" do
      planet = planet_fixture()
      assert {:ok, {planets, _}} = Planets.list_planets(%{})
      assert [^planet] = Enum.map(planets, &Planets.preload_all/1)
    end

    test "search_planets/1 returns only matching planets" do
      planet = planet_fixture(%{name: "foo bar baz"})
      planet_fixture(%{name: "foo bar"})
      planet_fixture(%{name: "foo"})

      assert {:ok, {planets, _}} = Planets.search_planets(["foo", "bar", "baz"], %{})
      assert [^planet] = Enum.map(planets, &Planets.preload_all/1)
    end

    test "get_planet!/1 returns the planet with given id" do
      planet = planet_fixture()
      assert ^planet = Planets.get_planet!(planet.id) |> Planets.preload_all()
    end

    test "get_planet/1 returns the planet with given id" do
      planet = planet_fixture()
      assert {:ok, returned_planet} = Planets.get_planet(planet.id)
      assert ^planet = Planets.preload_all(returned_planet)
    end

    test "get_planet/1 returns error when given id does not exist" do
      assert {:error, :not_found} = Planets.get_planet(42)
    end

    test "create_planet/1 with valid data creates a planet" do
      valid_attrs = %{
        name: "some name",
        diameter: "some diameter",
        rotation_period: "some rotation_period",
        orbital_period: "some orbital_period",
        gravity: "some gravity",
        population: "some population",
        climate: "some climate",
        terrain: "some terrain",
        surface_water: "some surface_water"
      }

      assert {:ok,
              %Planet{
                name: "some name",
                diameter: "some diameter",
                rotation_period: "some rotation_period",
                orbital_period: "some orbital_period",
                gravity: "some gravity",
                population: "some population",
                climate: "some climate",
                terrain: "some terrain",
                surface_water: "some surface_water"
              }} = Planets.create_planet(valid_attrs)
    end

    test "create_planet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Planets.create_planet(@invalid_attrs)
    end

    test "update_planet/2 with valid data updates the planet" do
      planet = planet_fixture()

      update_attrs = %{
        name: "some updated name",
        diameter: "some updated diameter",
        rotation_period: "some updated rotation_period",
        orbital_period: "some updated orbital_period",
        gravity: "some updated gravity",
        population: "some updated population",
        climate: "some updated climate",
        terrain: "some updated terrain",
        surface_water: "some updated surface_water"
      }

      assert {:ok,
              %Planet{
                name: "some updated name",
                diameter: "some updated diameter",
                rotation_period: "some updated rotation_period",
                orbital_period: "some updated orbital_period",
                gravity: "some updated gravity",
                population: "some updated population",
                climate: "some updated climate",
                terrain: "some updated terrain",
                surface_water: "some updated surface_water"
              }} = Planets.update_planet(planet, update_attrs)
    end

    test "update_planet/2 with invalid data returns error changeset" do
      planet = planet_fixture()
      assert {:error, %Ecto.Changeset{}} = Planets.update_planet(planet, @invalid_attrs)
      assert ^planet = Planets.get_planet!(planet.id) |> Planets.preload_all()
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
