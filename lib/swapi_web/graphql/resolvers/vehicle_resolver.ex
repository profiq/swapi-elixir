defmodule SWAPIWeb.GraphQL.Resolvers.VehicleResolver do
  @moduledoc """
  Vehicle resolver.
  """

  alias SWAPI.Vehicles

  @spec all(map, map) :: {:ok, list(Vehicle.t())} | {:error, any}
  def all(_args, _info) do
    {:ok, Vehicles.list_vehicles()}
  end

  @spec one(map, Absinthe.Resolution.t()) :: {:ok, Vehicle.t()} | {:error, any}
  def one(%{id: id}, _info) do
    case Vehicles.get_vehicle(id) do
      {:ok, vehicle} -> {:ok, vehicle}
      {:error, :not_found} -> {:error, "Vehicle not found"}
    end
  end

  @spec search(map, Absinthe.Blueprint.t()) :: {:ok, list(Vehicle.t())} | {:error, any}
  def search(%{search_terms: search_terms}, _info) do
    {:ok, Vehicles.search_vehicles(search_terms)}
  end
end
