defmodule SWAPI.People do
  @moduledoc """
  The People context.
  """

  import Ecto.Query, warn: false, except: [preload: 2]
  alias SWAPI.Repo

  alias SWAPI.Schemas.Person

  def preload(person, :all) do
    Repo.preload(person, [:films, :species, :starships, :vehicles])
  end

  def preload(person, associations) do
    Repo.preload(person, associations)
  end

  @doc """
  Returns the list of people.

  ## Examples

      iex> list_people()
      [%Person{}, ...]

  """
  def list_people do
    Person
    |> Repo.all()
    |> preload(:all)
  end

  def list_people(params), do: paginate(Person, params)

  defp paginate(query, params) do
    with {:ok, {people, meta}} = Flop.validate_and_run(query, params) do
      {:ok, {preload(people, :all), meta}}
    end
  end

  def search_people(terms, params) do
    people =
      Enum.reduce(terms, Person, fn term, query ->
        query
        |> where([p], ilike(p.name, ^"%#{term}%"))
      end)

    paginate(people, params)
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
  def get_person!(id) do
    Person
    |> Repo.get!(id)
    |> preload(:all)
  end

  def get_person(id) do
    with %Person{} = person <- Repo.get(Person, id) do
      {:ok, preload(person, :all)}
    else
      _ -> {:error, :not_found}
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
