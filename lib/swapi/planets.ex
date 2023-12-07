defmodule SWAPI.Planets do
  @moduledoc """
  The Planets context.
  """

  import Ecto.Query, warn: false
  alias SWAPI.Repo

  alias SWAPI.Schemas.Planet

  @doc """
  Returns the list of planets.

  ## Examples

      iex> list_planets()
      [%Planet{}, ...]

  """
  def list_planets do
    Planet
    |> Repo.all()
    |> Repo.preload([:residents, :films])
  end

  def list_planets(params) do
    with {:ok, {planets, meta}} = Flop.validate_and_run(Planet, params) do
      planets = Repo.preload(planets, [:residents, :films])
      {:ok, {planets, meta}}
    end
  end

  @doc """
  Gets a single planet.

  Raises `Ecto.NoResultsError` if the Planet does not exist.

  ## Examples

      iex> get_planet!(123)
      %Planet{}

      iex> get_planet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_planet!(id) do
    Planet
    |> Repo.get!(id)
    |> Repo.preload([:residents, :films])
  end

  @doc """
  Creates a planet.

  ## Examples

      iex> create_planet(%{field: value})
      {:ok, %Planet{}}

      iex> create_planet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_planet(attrs \\ %{}) do
    %Planet{}
    |> Planet.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a planet.

  ## Examples

      iex> update_planet(planet, %{field: new_value})
      {:ok, %Planet{}}

      iex> update_planet(planet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_planet(%Planet{} = planet, attrs) do
    planet
    |> Planet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a planet.

  ## Examples

      iex> delete_planet(planet)
      {:ok, %Planet{}}

      iex> delete_planet(planet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_planet(%Planet{} = planet) do
    Repo.delete(planet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking planet changes.

  ## Examples

      iex> change_planet(planet)
      %Ecto.Changeset{data: %Planet{}}

  """
  def change_planet(%Planet{} = planet, attrs \\ %{}) do
    Planet.changeset(planet, attrs)
  end
end
