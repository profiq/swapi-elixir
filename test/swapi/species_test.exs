defmodule SWAPI.SpeciesTest do
  use SWAPI.DataCase

  alias SWAPI.Species

  describe "species" do
    alias SWAPI.Schemas.Species, as: SpeciesSchema

    import SWAPI.SpeciesFixtures

    @invalid_attrs %{
      name: nil,
      classification: nil,
      designation: nil,
      average_height: nil,
      average_lifespan: nil,
      eye_colors: nil,
      hair_colors: nil,
      skin_colors: nil,
      language: nil
    }

    test "list_species/0 returns all species" do
      species = species_fixture()
      assert [^species] = Species.list_species() |> Enum.map(&Species.preload_all/1)
    end

    test "list_species/1 returns all species" do
      species = species_fixture()
      assert {:ok, {species_list, _}} = Species.list_species(%{})
      assert [^species] = species_list |> Enum.map(&Species.preload_all/1)
    end

    test "search_species/1 returns only matching species" do
      species = species_fixture(%{name: "foo bar baz"})
      species_fixture(%{name: "foo bar"})
      species_fixture(%{name: "foo"})

      assert {:ok, {species_list, _}} = Species.search_species(["foo", "bar", "baz"], %{})
      assert [^species] = species_list |> Enum.map(&Species.preload_all/1)
    end

    test "get_species!/1 returns the species with given id" do
      species = species_fixture()
      assert ^species = Species.get_species!(species.id) |> Species.preload_all()
    end

    test "get_species/1 returns the species with given id" do
      species = species_fixture()
      assert {:ok, returned_species} = Species.get_species(species.id)
      assert ^species = Species.preload_all(returned_species)
    end

    test "get_species/1 returns error when given id does not exist" do
      assert {:error, :not_found} = Species.get_species(42)
    end

    test "create_species/1 with valid data creates a species" do
      valid_attrs = %{
        name: "some name",
        classification: "some classification",
        designation: "some designation",
        average_height: "some average_height",
        average_lifespan: "some average_lifespan",
        eye_colors: "some eye_colors",
        hair_colors: "some hair_colors",
        skin_colors: "some skin_colors",
        language: "some language"
      }

      assert {:ok,
              %SpeciesSchema{
                name: "some name",
                classification: "some classification",
                designation: "some designation",
                average_height: "some average_height",
                average_lifespan: "some average_lifespan",
                eye_colors: "some eye_colors",
                hair_colors: "some hair_colors",
                skin_colors: "some skin_colors",
                language: "some language"
              }} = Species.create_species(valid_attrs)
    end

    test "create_species/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Species.create_species(@invalid_attrs)
    end

    test "update_species/2 with valid data updates the species" do
      species = species_fixture()

      update_attrs = %{
        name: "some updated name",
        classification: "some updated classification",
        designation: "some updated designation",
        average_height: "some updated average_height",
        average_lifespan: "some updated average_lifespan",
        eye_colors: "some updated eye_colors",
        hair_colors: "some updated hair_colors",
        skin_colors: "some updated skin_colors",
        language: "some updated language"
      }

      assert {:ok,
              %SpeciesSchema{
                name: "some updated name",
                classification: "some updated classification",
                designation: "some updated designation",
                average_height: "some updated average_height",
                average_lifespan: "some updated average_lifespan",
                eye_colors: "some updated eye_colors",
                hair_colors: "some updated hair_colors",
                skin_colors: "some updated skin_colors",
                language: "some updated language"
              }} = Species.update_species(species, update_attrs)
    end

    test "update_species/2 with invalid data returns error changeset" do
      species = species_fixture()
      assert {:error, %Ecto.Changeset{}} = Species.update_species(species, @invalid_attrs)
      assert ^species = Species.get_species!(species.id) |> Species.preload_all()
    end

    test "delete_species/1 deletes the species" do
      species = species_fixture()
      assert {:ok, %SpeciesSchema{}} = Species.delete_species(species)
      assert_raise Ecto.NoResultsError, fn -> Species.get_species!(species.id) end
    end

    test "change_species/1 returns a species changeset" do
      species = species_fixture()
      assert %Ecto.Changeset{} = Species.change_species(species)
    end
  end
end
