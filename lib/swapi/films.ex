defmodule SWAPI.Films do
  @moduledoc """
  The Films context.
  """

  alias SWAPI.Repo
  alias SWAPI.Schemas.Film

  import Ecto.Query, warn: false, except: [preload: 2]
  import SWAPI.Util

  def preload(film, :all) do
    Repo.preload(film, [:species, :starships, :vehicles, :characters, :planets])
  end

  def preload(film, associations) do
    Repo.preload(film, associations)
  end

  @doc """
  Returns the list of films.

  ## Examples

      iex> list_films()
      [%Film{}, ...]

  """
  def list_films do
    Film
    |> Repo.all()
    |> preload(:all)
  end

  def list_films(params) do
    with {:ok, {films, meta}} <- paginate(Film, params) do
      {:ok, {preload(films, :all), meta}}
    end
  end

  def search_films(terms, params) do
    films =
      Enum.reduce(terms, Film, fn term, query ->
        query
        |> where([f], like(f.title, ^"%#{term}%"))
      end)

    with {:ok, {films, meta}} <- paginate(films, params) do
      {:ok, {preload(films, :all), meta}}
    end
  end

  @doc """
  Gets a single film.

  Raises `Ecto.NoResultsError` if the Film does not exist.

  ## Examples

      iex> get_film!(123)
      %Film{}

      iex> get_film!(456)
      ** (Ecto.NoResultsError)

  """
  def get_film!(id) do
    Film
    |> Repo.get!(id)
    |> preload(:all)
  end

  def get_film(id) do
    with %Film{} = film <- Repo.get(Film, id) do
      {:ok, preload(film, :all)}
    else
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Creates a film.

  ## Examples

      iex> create_film(%{field: value})
      {:ok, %Film{}}

      iex> create_film(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_film(attrs \\ %{}) do
    %Film{}
    |> Film.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a film.

  ## Examples

      iex> update_film(film, %{field: new_value})
      {:ok, %Film{}}

      iex> update_film(film, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_film(%Film{} = film, attrs) do
    film
    |> Film.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a film.

  ## Examples

      iex> delete_film(film)
      {:ok, %Film{}}

      iex> delete_film(film)
      {:error, %Ecto.Changeset{}}

  """
  def delete_film(%Film{} = film) do
    Repo.delete(film)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking film changes.

  ## Examples

      iex> change_film(film)
      %Ecto.Changeset{data: %Film{}}

  """
  def change_film(%Film{} = film, attrs \\ %{}) do
    Film.changeset(film, attrs)
  end
end
