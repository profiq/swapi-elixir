defmodule SWAPI.Planets do
  @moduledoc """
  The Planets context.
  """

  import Ecto.Query, warn: false, except: [preload: 2]
  alias SWAPI.Repo

  alias SWAPI.Schemas.Planet

  def preload(planet, :all) do
    Repo.preload(planet, [:residents, :films])
  end

  def preload(planet, associations) do
    Repo.preload(planet, associations)
  end

  @doc """
  Returns the list of planets.

  ## Examples

      iex> list_planets()
      [%Planet{}, ...]

  """
  def list_planets do
    Planet
    |> Repo.all()
    |> preload(:all)
  end

  def list_planets(params), do: paginate(Planet, params)

  defp paginate(query, params) do
    with {:ok, {planets, meta}} = Flop.validate_and_run(query, params) do
      {:ok, {preload(planets, :all), meta}}
    end
  end

  def search_planets(terms, params) do
    planets =
      Enum.reduce(terms, Planet, fn term, query ->
        query
        |> where([p], like(p.name, ^"%#{term}%"))
      end)

    paginate(planets, params)
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
    |> preload(:all)
  end

  def get_planet(id) do
    with %Planet{} = planet <- Repo.get(Planet, id) do
      {:ok, preload(planet, :all)}
    else
      _ -> {:error, :not_found}
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
