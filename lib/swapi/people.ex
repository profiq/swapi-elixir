defmodule SWAPI.People do
  @moduledoc """
  The People context.
  """

  alias SWAPI.Repo
  alias SWAPI.Schemas.Person

  import Ecto.Query, warn: false
  import SWAPI.Pagination

  def preload_all(person) do
    Repo.preload(person, [:homeworld, :films, :species, :starships, :vehicles])
  end

  @doc """
  Returns the list of people.

  ## Examples

      iex> list_people()
      [%Person{}, ...]

  """
  def list_people, do: Repo.all(Person)

  def list_people(params), do: paginate(Person, params)

  def search_people(terms) do
    terms
    |> Enum.reduce(Person, fn term, query ->
      query
      |> where([p], like(p.name, ^"%#{term}%"))
    end)
    |> Repo.all()
  end

  def search_people(terms, params) do
    terms
    |> Enum.reduce(Person, fn term, query ->
      query
      |> where([p], like(p.name, ^"%#{term}%"))
    end)
    |> paginate(params)
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id), do: Repo.get!(Person, id)

  def get_person(id) do
    case Repo.get(Person, id) do
      %Person{} = person ->
        {:ok, person}

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{data: %Person{}}

  """
  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end
end
