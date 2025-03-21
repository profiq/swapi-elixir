defmodule SWAPI.StarshipsTest do
  use SWAPI.DataCase

  alias SWAPI.Starships

  describe "starships" do
    alias SWAPI.Schemas.Starship

    import SWAPI.StarshipsFixtures

    @invalid_attrs %{
      transport: %{
        name: nil,
        model: nil,
        manufacturer: nil,
        length: nil,
        cost_in_credits: nil,
        crew: nil,
        passengers: nil,
        max_atmosphering_speed: nil,
        cargo_capacity: nil,
        consumables: nil
      },
      starship_class: nil,
      hyperdrive_rating: nil,
      mglt: nil
    }

    test "list_starships/0 returns all starships" do
      starship = starship_fixture()
      assert [^starship] = Starships.list_starships() |> Enum.map(&Starships.preload_all/1)
    end

    test "list_starships/1 returns all starships" do
      starship = starship_fixture()
      assert {:ok, {starships, _}} = Starships.list_starships(%{})
      assert [^starship] = Enum.map(starships, &Starships.preload_all/1)
    end

    test "search_starships/1 returns only matching starships" do
      starship1 = starship_fixture(%{transport: %{name: "foo bar baz"}})
      starship2 = starship_fixture(%{transport: %{model: "foo bar baz"}})

      starship_fixture(%{transport: %{name: "foo bar"}})
      starship_fixture(%{transport: %{name: "bar baz"}})
      starship_fixture(%{transport: %{model: "foo"}})
      starship_fixture(%{transport: %{model: "bar"}})

      {:ok, {starships, _}} = Starships.search_starships(["foo", "bar", "baz"], %{})
      starships = Enum.map(starships, &Starships.preload_all/1)

      assert length(starships) == 2
      assert starship1 in starships
      assert starship2 in starships
    end

    test "get_starship!/1 returns the starship with given id" do
      starship = starship_fixture()
      assert ^starship = Starships.get_starship!(starship.id) |> Starships.preload_all()
    end

    test "get_starship/1 returns the starship with given id" do
      starship = starship_fixture()
      assert {:ok, returned_starship} = Starships.get_starship(starship.id)
      assert ^starship = Starships.preload_all(returned_starship)
    end

    test "get_starship/1 returns error when given id does not exist" do
      assert {:error, :not_found} = Starships.get_starship(42)
    end

    test "create_starship/1 with valid data creates a starship" do
      valid_attrs = %{
        transport: %{
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
        },
        starship_class: "some starship_class",
        hyperdrive_rating: "some hyperdrive_rating",
        mglt: "some mglt"
      }

      assert {:ok, starship} = Starships.create_starship(valid_attrs)

      assert %Starship{
               transport: %{
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
               },
               starship_class: "some starship_class",
               hyperdrive_rating: "some hyperdrive_rating",
               mglt: "some mglt"
             } = Starships.preload_all(starship)
    end

    test "create_starship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Starships.create_starship(@invalid_attrs)
    end

    test "update_starship/2 with valid data updates the starship" do
      starship = starship_fixture()

      update_attrs = %{
        transport: %{
          name: "some updated name",
          model: "some updated model",
          manufacturer: "some updated manufacturer",
          length: "some updated length",
          cost_in_credits: "some updated cost_in_credits",
          crew: "some updated crew",
          passengers: "some updated passengers",
          max_atmosphering_speed: "some updated max_atmosphering_speed",
          cargo_capacity: "some updated cargo_capacity",
          consumables: "some updated consumables"
        },
        starship_class: "some updated starship_class",
        hyperdrive_rating: "some updated hyperdrive_rating",
        mglt: "some updated mglt"
      }

      assert {:ok, %Starship{} = starship} = Starships.update_starship(starship, update_attrs)

      assert %Starship{
               transport: %{
                 name: "some updated name",
                 model: "some updated model",
                 manufacturer: "some updated manufacturer",
                 length: "some updated length",
                 cost_in_credits: "some updated cost_in_credits",
                 crew: "some updated crew",
                 passengers: "some updated passengers",
                 max_atmosphering_speed: "some updated max_atmosphering_speed",
                 cargo_capacity: "some updated cargo_capacity",
                 consumables: "some updated consumables"
               },
               starship_class: "some updated starship_class",
               hyperdrive_rating: "some updated hyperdrive_rating",
               mglt: "some updated mglt"
             } = Starships.preload_all(starship)
    end

    test "update_starship/2 with invalid data returns error changeset" do
      starship = starship_fixture()
      assert {:error, %Ecto.Changeset{}} = Starships.update_starship(starship, @invalid_attrs)
      assert ^starship = Starships.get_starship!(starship.id) |> Starships.preload_all()
    end

    test "delete_starship/1 deletes the starship" do
      starship = starship_fixture()
      assert {:ok, %Starship{}} = Starships.delete_starship(starship)
      assert_raise Ecto.NoResultsError, fn -> Starships.get_starship!(starship.id) end
    end

    test "change_starship/1 returns a starship changeset" do
      starship = starship_fixture()
      assert %Ecto.Changeset{} = Starships.change_starship(starship)
    end
  end
end
