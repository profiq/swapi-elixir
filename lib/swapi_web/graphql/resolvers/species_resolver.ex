defmodule SWAPIWeb.GraphQL.Resolvers.SpeciesResolver do
  @moduledoc """
  Species resolver.
  """

  alias SWAPI.Species

  @spec all(map, map) :: {:ok, list(Species.t())} | {:error, any}
  def all(_args, _info) do
    {:ok, Species.list_species()}
  end

  @spec one(map, Absinthe.Resolution.t()) :: {:ok, Species.t()} | {:error, any}
  def one(%{id: id}, _info) do
    case Species.get_species(id) do
      {:ok, species} -> {:ok, species}
      {:error, :not_found} -> {:error, "Species not found"}
    end
  end
end
