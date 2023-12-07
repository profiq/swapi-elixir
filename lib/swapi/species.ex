defmodule SWAPI.Species do
  @moduledoc """
  The Species context.
  """

  import Ecto.Query, warn: false
  alias SWAPI.Repo

  alias SWAPI.Schemas.Species

  @doc """
  Returns the list of species.

  ## Examples

      iex> list_species()
      [%Species{}, ...]

  """
  def list_species do
    Species
    |> Repo.all()
    |> Repo.preload([:homeworld, :people, :films])
  end

  def list_species(params) do
    with {:ok, {species, meta}} = Flop.validate_and_run(Species, params) do
      species = Repo.preload(species, [:homeworld, :people, :films])
      {:ok, {species, meta}}
    end
  end

  @doc """
  Gets a single species.

  Raises `Ecto.NoResultsError` if the Species does not exist.

  ## Examples

      iex> get_species!(123)
      %Species{}

      iex> get_species!(456)
      ** (Ecto.NoResultsError)

  """
  def get_species!(id) do
    Species
    |> Repo.get!(id)
    |> Repo.preload([:homeworld, :people, :films])
  end

  @doc """
  Creates a species.

  ## Examples

      iex> create_species(%{field: value})
      {:ok, %Species{}}

      iex> create_species(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_species(attrs \\ %{}) do
    %Species{}
    |> Species.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a species.

  ## Examples

      iex> update_species(species, %{field: new_value})
      {:ok, %Species{}}

      iex> update_species(species, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_species(%Species{} = species, attrs) do
    species
    |> Species.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a species.

  ## Examples

      iex> delete_species(species)
      {:ok, %Species{}}

      iex> delete_species(species)
      {:error, %Ecto.Changeset{}}

  """
  def delete_species(%Species{} = species) do
    Repo.delete(species)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking species changes.

  ## Examples

      iex> change_species(species)
      %Ecto.Changeset{data: %Species{}}

  """
  def change_species(%Species{} = species, attrs \\ %{}) do
    Species.changeset(species, attrs)
  end
end
