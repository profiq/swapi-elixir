defmodule SWAPI.Vehicles do
  @moduledoc """
  The Vehicles context.
  """

  alias SWAPI.Repo
  alias SWAPI.Schemas.Transport
  alias SWAPI.Schemas.Vehicle

  import Ecto.Query, warn: false
  import SWAPI.Pagination

  def preload_all(vehicle) do
    Repo.preload(vehicle, [:transport, :films, :pilots])
  end

  @doc """
  Returns the list of vehicles.

  ## Examples

      iex> list_vehicles()
      [%Vehicle{}, ...]

  """
  def list_vehicles do
    Vehicle
    |> Repo.all()
    |> preload_all()
  end

  def list_vehicles(params) do
    with {:ok, {vehicles, meta}} <- paginate(Vehicle, params) do
      {:ok, {preload_all(vehicles), meta}}
    end
  end

  def search_vehicles(terms, params) do
    query =
      Vehicle
      |> join(:left, [v], t in Transport, on: v.id == t.id)

    vehicles =
      Enum.reduce(terms, query, fn term, query ->
        query
        |> where([v, t], like(t.name, ^"%#{term}%") or like(t.model, ^"%#{term}%"))
      end)

    with {:ok, {vehicles, meta}} <- paginate(vehicles, params) do
      {:ok, {preload_all(vehicles), meta}}
    end
  end

  @doc """
  Gets a single vehicle.

  Raises `Ecto.NoResultsError` if the Vehicle does not exist.

  ## Examples

      iex> get_vehicle!(123)
      %Vehicle{}

      iex> get_vehicle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vehicle!(id) do
    Vehicle
    |> Repo.get!(id)
    |> preload_all()
  end

  def get_vehicle(id) do
    case Repo.get(Vehicle, id) do
      %Vehicle{} = vehicle ->
        {:ok, preload_all(vehicle)}

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Creates a vehicle.

  ## Examples

      iex> create_vehicle(%{field: value})
      {:ok, %Vehicle{}}

      iex> create_vehicle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vehicle(attrs \\ %{}) do
    %Vehicle{}
    |> Vehicle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a vehicle.

  ## Examples

      iex> update_vehicle(vehicle, %{field: new_value})
      {:ok, %Vehicle{}}

      iex> update_vehicle(vehicle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vehicle(%Vehicle{} = vehicle, attrs) do
    vehicle
    |> Vehicle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vehicle.

  ## Examples

      iex> delete_vehicle(vehicle)
      {:ok, %Vehicle{}}

      iex> delete_vehicle(vehicle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vehicle(%Vehicle{} = vehicle) do
    Repo.delete(vehicle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vehicle changes.

  ## Examples

      iex> change_vehicle(vehicle)
      %Ecto.Changeset{data: %Vehicle{}}

  """
  def change_vehicle(%Vehicle{} = vehicle, attrs \\ %{}) do
    Vehicle.changeset(vehicle, attrs)
  end
end
