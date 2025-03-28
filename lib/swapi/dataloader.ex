defmodule SWAPI.Dataloader do
  @moduledoc """
  Dataloader for GraphQL
  """

  def data, do: Dataloader.Ecto.new(SWAPI.Repo, query: &query/2)

  def query(queryable, _params), do: queryable
end
