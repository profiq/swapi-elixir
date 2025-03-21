defmodule SWAPIWeb.GraphQL.Resolvers.SpeciesResolver do
  @moduledoc """
  Species resolver.
  """

  alias SWAPI.Species
  alias SWAPI.Schemas.Species, as: SpeciesSchema

  @spec all(map, map) :: {:ok, list(SpeciesSchema.t())} | {:error, any}
  def all(_args, _info) do
    {:ok, Species.list_species()}
  end

  @spec one(map, Absinthe.Resolution.t()) :: {:ok, SpeciesSchema.t()} | {:error, any}
  def one(%{id: id}, _info) do
    case Species.get_species(id) do
      {:ok, species} -> {:ok, species}
      {:error, :not_found} -> {:error, "Species not found"}
    end
  end

  @spec search(map, Absinthe.Blueprint.t()) :: {:ok, list(SpeciesSchema.t())} | {:error, any}
  def search(%{search_terms: search_terms}, _info) do
    {:ok, Species.search_species(search_terms)}
  end
end
