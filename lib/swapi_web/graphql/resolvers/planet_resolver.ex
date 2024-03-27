defmodule SWAPIWeb.GraphQL.Resolvers.PlanetResolver do
  @moduledoc """
  Planet resolver.
  """

  alias SWAPI.Planets

  @spec all(map, map) :: {:ok, list(Planet.t())} | {:error, any}
  def all(_args, _info) do
    {:ok, Planets.list_planets()}
  end

  @spec one(map, Absinthe.Resolution.t()) :: {:ok, Planet.t()} | {:error, any}
  def one(%{id: id}, _info) do
    case Planets.get_planet(id) do
      {:ok, planet} -> {:ok, planet}
      {:error, :not_found} -> {:error, "Planet not found"}
    end
  end
end
