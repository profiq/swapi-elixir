defmodule SWAPIWeb.GraphQL.Resolvers.PersonResolver do
  @moduledoc """
  Person resolver.
  """

  alias SWAPI.People

  @spec all(map, map) :: {:ok, list(Person.t())} | {:error, any}
  def all(_args, _info) do
    {:ok, People.list_people()}
  end

  @spec one(map, Absinthe.Resolution.t()) :: {:ok, Person.t()} | {:error, any}
  def one(%{id: id}, _info) do
    case People.get_person(id) do
      {:ok, person} -> {:ok, person}
      {:error, :not_found} -> {:error, "Person not found"}
    end
  end
end
