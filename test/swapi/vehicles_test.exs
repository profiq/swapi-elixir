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
      assert Vehicles.list_vehicles() == [vehicle]
    end

    test "list_vehicles/1 returns all vehicles" do
      vehicle = vehicle_fixture()
      assert {:ok, {[^vehicle], _}} = Vehicles.list_vehicles(%{})
    end

    test "search_vehicles/1 returns only matching vehicles" do
      vehicle1 = vehicle_fixture(%{transport: %{name: "foo bar baz"}})
      vehicle2 = vehicle_fixture(%{transport: %{model: "foo bar baz"}})

      vehicle_fixture(%{transport: %{name: "foo bar"}})
      vehicle_fixture(%{transport: %{name: "bar baz"}})
      vehicle_fixture(%{transport: %{model: "foo"}})
      vehicle_fixture(%{transport: %{model: "bar"}})

      {:ok, {vehicles, _}} = Vehicles.search_vehicles(["foo", "bar", "baz"], %{})
      assert length(vehicles) == 2
      assert vehicle1 in vehicles
      assert vehicle2 in vehicles
    end

    test "get_vehicle!/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Vehicles.get_vehicle!(vehicle.id) == vehicle
    end

    test "get_vehicle/1 returns the vehicle with given id" do
      vehicle = vehicle_fixture()
      assert Vehicles.get_vehicle(vehicle.id) == {:ok, vehicle}
    end

    test "get_vehicle/1 returns error when given id does not exist" do
      assert Vehicles.get_vehicle(42) == {:error, :not_found}
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
      assert vehicle.transport.name == "some name"
      assert vehicle.transport.model == "some model"
      assert vehicle.transport.manufacturer == "some manufacturer"
      assert vehicle.transport.length == "some length"
      assert vehicle.transport.cost_in_credits == "some cost_in_credits"
      assert vehicle.transport.crew == "some crew"
      assert vehicle.transport.passengers == "some passengers"
      assert vehicle.transport.max_atmosphering_speed == "some max_atmosphering_speed"
      assert vehicle.transport.cargo_capacity == "some cargo_capacity"
      assert vehicle.transport.consumables == "some consumables"
      assert vehicle.vehicle_class == "some vehicle_class"
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
      assert vehicle.transport.name == "some updated name"
      assert vehicle.transport.model == "some updated model"
      assert vehicle.transport.manufacturer == "some updated manufacturer"
      assert vehicle.transport.length == "some updated length"
      assert vehicle.transport.cost_in_credits == "some updated cost_in_credits"
      assert vehicle.transport.crew == "some updated crew"
      assert vehicle.transport.passengers == "some updated passengers"
      assert vehicle.transport.max_atmosphering_speed == "some updated max_atmosphering_speed"
      assert vehicle.transport.cargo_capacity == "some updated cargo_capacity"
      assert vehicle.transport.consumables == "some updated consumables"
      assert vehicle.vehicle_class == "some updated vehicle_class"
    end

    test "update_vehicle/2 with invalid data returns error changeset" do
      vehicle = vehicle_fixture()
      assert {:error, %Ecto.Changeset{}} = Vehicles.update_vehicle(vehicle, @invalid_attrs)
      assert vehicle == Vehicles.get_vehicle!(vehicle.id)
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
