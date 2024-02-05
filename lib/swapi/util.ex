defmodule SWAPI.Util do
  @moduledoc """
  Utility functions
  """

  @type page_info() :: %{
          count: non_neg_integer,
          next: non_neg_integer | nil,
          previous: non_neg_integer | nil
        }

  @page_size 10

  @doc """
  Queries the given Ecto queryable with pagination.
  """
  @spec paginate(Ecto.Queryable.t(), map()) :: {:ok, {list, page_info}} | {:error, atom}
  def paginate(query, params) do
    with {:ok, page} <- get_page_number(params),
         {list, meta} <- Flop.validate_and_run!(query, %Flop{page: page, page_size: @page_size}) do
      {:ok,
       {list, %{count: meta.total_count, next: meta.next_page, previous: meta.previous_page}}}
    end
  end

  defp get_page_number(%{"page" => page}) when is_binary(page) do
    case Integer.parse(page) do
      :error -> {:error, :bad_request}
      {page, _} -> {:ok, page}
    end
  end

  defp get_page_number(%{"offset" => offset}) when is_binary(offset) do
    case Integer.parse(offset) do
      :error -> {:error, :bad_request}
      {offset, _} -> {:ok, div(offset, @page_size)}
    end
  end

  defp get_page_number(_params), do: {:ok, 1}
end
