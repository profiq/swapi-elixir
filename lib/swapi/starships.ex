defmodule SWAPI.Starships do
  @moduledoc """
  The Starships context.
  """

  import Ecto.Query, warn: false
  alias SWAPI.Repo

  alias SWAPI.Schemas.Starship

  @doc """
  Returns the list of starships.

  ## Examples

      iex> list_starships()
      [%Starship{}, ...]

  """
  def list_starships do
    Starship
    |> Repo.all()
    |> Repo.preload([:transport, :films, :pilots])
  end

  @doc """
  Gets a single starship.

  Raises `Ecto.NoResultsError` if the Starship does not exist.

  ## Examples

      iex> get_starship!(123)
      %Starship{}

      iex> get_starship!(456)
      ** (Ecto.NoResultsError)

  """
  def get_starship!(id) do
    Starship
    |> Repo.get!(id)
    |> Repo.preload([:transport, :films, :pilots])
  end

  @doc """
  Creates a starship.

  ## Examples

      iex> create_starship(%{field: value})
      {:ok, %Starship{}}

      iex> create_starship(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_starship(attrs \\ %{}) do
    %Starship{}
    |> Starship.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a starship.

  ## Examples

      iex> update_starship(starship, %{field: new_value})
      {:ok, %Starship{}}

      iex> update_starship(starship, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_starship(%Starship{} = starship, attrs) do
    starship
    |> Starship.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a starship.

  ## Examples

      iex> delete_starship(starship)
      {:ok, %Starship{}}

      iex> delete_starship(starship)
      {:error, %Ecto.Changeset{}}

  """
  def delete_starship(%Starship{} = starship) do
    Repo.delete(starship)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking starship changes.

  ## Examples

      iex> change_starship(starship)
      %Ecto.Changeset{data: %Starship{}}

  """
  def change_starship(%Starship{} = starship, attrs \\ %{}) do
    Starship.changeset(starship, attrs)
  end
end
