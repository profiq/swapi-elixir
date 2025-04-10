defmodule SWAPI.Films do
  @moduledoc """
  The Films context.
  """

  alias SWAPI.Repo
  alias SWAPI.Schemas.Film

  import Ecto.Query, warn: false
  import SWAPI.Pagination

  def preload_all(film) do
    Repo.preload(film, [:species, :starships, :vehicles, :characters, :planets])
  end

  @doc """
  Returns the list of films.

  ## Examples

      iex> list_films()
      [%Film{}, ...]

  """
  def list_films, do: Repo.all(Film)

  def list_films(params), do: paginate(Film, params)

  def search_films(terms) do
    terms
    |> Enum.reduce(Film, fn term, query ->
      query
      |> where([f], like(f.title, ^"%#{term}%"))
    end)
    |> Repo.all()
  end

  def search_films(terms, params) do
    terms
    |> Enum.reduce(Film, fn term, query ->
      query
      |> where([f], like(f.title, ^"%#{term}%"))
    end)
    |> paginate(params)
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
  def get_film!(id), do: Repo.get!(Film, id)

  def get_film(id) do
    case Repo.get(Film, id) do
      %Film{} = film ->
        {:ok, film}

      _ ->
        {:error, :not_found}
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
