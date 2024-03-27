defmodule SWAPI do
  @moduledoc """
  SWAPI keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def data(), do: Dataloader.Ecto.new(SWAPI.Repo, query: &query/2)

  def query(queryable, _params), do: queryable
end
