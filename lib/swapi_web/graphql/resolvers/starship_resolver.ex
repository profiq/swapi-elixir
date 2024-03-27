defmodule SWAPIWeb.GraphQL.Resolvers.StarshipResolver do
  @moduledoc """
  Starship resolver.
  """

  alias SWAPI.Starships

  @spec all(map, map) :: {:ok, list(Starship.t())} | {:error, any}
  def all(_args, _info) do
    {:ok, Starships.list_starships()}
  end

  @spec one(map, Absinthe.Resolution.t()) :: {:ok, Starship.t()} | {:error, any}
  def one(%{id: id}, _info) do
    case Starships.get_starship(id) do
      {:ok, starship} -> {:ok, starship}
      {:error, :not_found} -> {:error, "Starship not found"}
    end
  end
end
