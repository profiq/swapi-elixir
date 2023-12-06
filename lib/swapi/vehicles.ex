defmodule SWAPI.Vehicles do
  @moduledoc """
  The Vehicles context.
  """

  import Ecto.Query, warn: false
  alias SWAPI.Repo

  alias SWAPI.Schemas.Vehicle

  @doc """
  Returns the list of vehicles.

  ## Examples

      iex> list_vehicles()
      [%Vehicle{}, ...]

  """
  def list_vehicles do
    Vehicle
    |> Repo.all()
    |> Repo.preload([:transport, :films, :pilots])
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
    |> Repo.preload([:transport, :films, :pilots])
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
