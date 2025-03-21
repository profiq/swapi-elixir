defmodule SWAPI.VehiclesTest do
  use SWAPI.DataCase

  alias SWAPI.Vehicles

  describe "vehicles" do
    alias SWAPI.Schemas.Vehicle

    import SWAPI.VehiclesFixtures

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
      vehicle_class: nil
    }

    test "list_vehicles/0 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert [^vehicle] = Vehicles.list_vehicles() |> Enum.map(&Vehicles.preload_all/1)
    end

    test "list_vehicles/1 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert {:ok, {vehicles, _}} = Vehicles.list_vehicles(%{})
      assert [^vehicle] = Enum.map(vehicles, &Vehicles.preload_all/1)
    end

    test "search_vehicles/1 returns only matching vehicles" do
      vehicle1 = vehicle_fixture(%{transport: %{name: "foo bar baz"}})
      vehicle2 = vehicle_fixture(%{transport: %{model: "foo bar baz"}})

      vehicle_fixture(%{transport: %{name: "foo bar"}})
      vehicle_fixture(%{transport: %{name: "bar baz"}})
      vehicle_fixture(%{transport: %{model: "foo"}})
      vehicle_fixture(%{transport: %{model: "bar"}})

      {:ok, {vehicles, _}} = Vehicles.search_vehicles(["foo", "bar", "baz"], %{})
      vehicles = Enum.map(vehicles, &Vehicles.preload_all/1)

      assert length(vehicles) == 2
      assert vehicle1 in vehicles
      assert vehicle2 in vehicles
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert ^vehicle = Vehicles.get_vehicle!(vehicle.id) |> Vehicles.preload_all()
    end

    test "get_vehicle/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert {:ok, returned_vehicle} = Vehicles.get_vehicle(vehicle.id)
      assert ^vehicle = Vehicles.preload_all(returned_vehicle)
    end

    test "get_vehicle/1 returns error when given id does not exist" do
      assert {:error, :not_found} = Vehicles.get_vehicle(42)
    end

    test "create_vehicle/1 with valid data creates a vehicle" do
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
        vehicle_class: "some vehicle_class"
      }

      assert {:ok, %Vehicle{} = vehicle} = Vehicles.create_vehicle(valid_attrs)

      assert %Vehicle{
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
               vehicle_class: "some vehicle_class"
             } = Vehicles.preload_all(vehicle)
    end

    test "create_vehicle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vehicles.create_vehicle(@invalid_attrs)
    end

    test "update_vehicle/2 with valid data updates the vehicle" do
      vehicle = vehicle_fixture()

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
        vehicle_class: "some updated vehicle_class"
      }

      assert {:ok, %Vehicle{} = vehicle} = Vehicles.update_vehicle(vehicle, update_attrs)

      assert %Vehicle{
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
               vehicle_class: "some updated vehicle_class"
             } = Vehicles.preload_all(vehicle)
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicles.update_vehicle(vehicle, @invalid_attrs)
      assert ^vehicle = Vehicles.get_vehicle!(vehicle.id) |> Vehicles.preload_all()
    end

    test "delete_vehicle/1 deletes the vehicle" do
      vehicle = vehicle_fixture()
      assert {:ok, %Vehicle{}} = Vehicles.delete_vehicle(vehicle)
      assert_raise Ecto.NoResultsError, fn -> Vehicles.get_vehicle!(vehicle.id) end
    end

    test "change_vehicle/1 returns a vehicle changeset" do
      vehicle = vehicle_fixture()
      assert %Ecto.Changeset{} = Vehicles.change_vehicle(vehicle)
    end
  end
end
