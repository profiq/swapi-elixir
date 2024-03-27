defmodule SWAPIWeb.GraphQL.Resolvers.FilmResolver do
  @moduledoc """
  Film resolver.
  """

  alias SWAPI.Films

  @spec all(map, map) :: {:ok, list(Film.t())} | {:error, any}
  def all(_args, _info) do
    {:ok, Films.list_films()}
  end

  @spec one(map, Absinthe.Blueprint.t()) :: {:ok, Film.t()} | {:error, any}
  def one(%{id: id}, _info) do
    case Films.get_film(id) do
      {:ok, film} -> {:ok, film}
      {:error, :not_found} -> {:error, "Film not found"}
    end
  end

  @spec search(map, Absinthe.Blueprint.t()) :: {:ok, list(Film.t())} | {:error, any}
  def search(%{search_terms: search_terms}, _info) do
    {:ok, Films.search_films(search_terms)}
  end
end
