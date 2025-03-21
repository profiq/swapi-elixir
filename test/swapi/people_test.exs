defmodule SWAPI.PeopleTest do
  use SWAPI.DataCase

  alias SWAPI.People

  describe "people" do
    alias SWAPI.Schemas.Person

    import SWAPI.PeopleFixtures

    @invalid_attrs %{
      name: nil,
      birth_year: nil,
      eye_color: nil,
      gender: nil,
      hair_color: nil,
      height: nil,
      mass: nil,
      skin_color: nil
    }

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert [^person] = People.list_people() |> Enum.map(&People.preload_all/1)
    end

    test "list_people/1 returns all people" do
      person = person_fixture()
      assert {:ok, {people, _}} = People.list_people(%{})
      assert [^person] = Enum.map(people, &People.preload_all/1)
    end

    test "search_people/1 returns only matching people" do
      person = person_fixture(%{name: "foo bar baz"})
      person_fixture(%{name: "foo bar"})
      person_fixture(%{name: "foo"})

      assert {:ok, {people, _}} = People.search_people(["foo", "bar", "baz"], %{})
      assert [^person] = Enum.map(people, &People.preload_all/1)
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert ^person = People.get_person!(person.id) |> People.preload_all()
    end

    test "get_person/1 returns the person with given id" do
      person = person_fixture()
      assert {:ok, returned_person} = People.get_person(person.id)
      assert ^person = People.preload_all(returned_person)
    end

    test "get_person/1 returns error when given id does not exist" do
      assert {:error, :not_found} = People.get_person(42)
    end

    test "create_person/1 with valid data creates a person" do
      valid_attrs = %{
        name: "some name",
        birth_year: "some birth_year",
        eye_color: "some eye_color",
        gender: "some gender",
        hair_color: "some hair_color",
        height: "some height",
        mass: "some mass",
        skin_color: "some skin_color"
      }

      assert {:ok,
              %Person{
                name: "some name",
                birth_year: "some birth_year",
                eye_color: "some eye_color",
                gender: "some gender",
                hair_color: "some hair_color",
                height: "some height",
                mass: "some mass",
                skin_color: "some skin_color"
              }} = People.create_person(valid_attrs)
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = People.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()

      update_attrs = %{
        name: "some updated name",
        birth_year: "some updated birth_year",
        eye_color: "some updated eye_color",
        gender: "some updated gender",
        hair_color: "some updated hair_color",
        height: "some updated height",
        mass: "some updated mass",
        skin_color: "some updated skin_color"
      }

      assert {:ok,
              %Person{
                name: "some updated name",
                birth_year: "some updated birth_year",
                eye_color: "some updated eye_color",
                gender: "some updated gender",
                hair_color: "some updated hair_color",
                height: "some updated height",
                mass: "some updated mass",
                skin_color: "some updated skin_color"
              }} = People.update_person(person, update_attrs)
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = People.update_person(person, @invalid_attrs)
      assert ^person = People.get_person!(person.id) |> People.preload_all()
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = People.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> People.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = People.change_person(person)
    end
  end
end
