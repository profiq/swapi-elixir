defmodule SWAPI.Planets do
  @moduledoc """
  The Planets context.
  """

  alias SWAPI.Repo
  alias SWAPI.Schemas.Planet

  import Ecto.Query, warn: false
  import SWAPI.Pagination

  def preload_all(planet) do
    Repo.preload(planet, [:residents, :films])
  end

  @doc """
  Returns the list of planets.

  ## Examples

      iex> list_planets()
      [%Planet{}, ...]

  """
  def list_planets, do: Repo.all(Planet)

  def list_planets(params), do: paginate(Planet, params)

  def search_planets(terms) do
    terms
    |> Enum.reduce(Planet, fn term, query ->
      query
      |> where([p], like(p.name, ^"%#{term}%"))
    end)
    |> Repo.all()
  end

  def search_planets(terms, params) do
    terms
    |> Enum.reduce(Planet, fn term, query ->
      query
      |> where([p], like(p.name, ^"%#{term}%"))
    end)
    |> paginate(params)
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
  def get_planet!(id), do: Repo.get!(Planet, id)

  def get_planet(id) do
    case Repo.get(Planet, id) do
      %Planet{} = planet ->
        {:ok, planet}

      _ ->
        {:error, :not_found}
    end
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
