defmodule SWAPI.Pagination do
  @moduledoc """
  Utility functions
  """

  @type pagination_method :: :page | :offset
  @type page_info() :: %{
          count: non_neg_integer,
          next: {pagination_method, non_neg_integer} | nil,
          previous: {pagination_method, non_neg_integer} | nil
        }

  @default_page_size 10

  @doc """
  Queries the given Ecto queryable with pagination.
  """
  @spec paginate(Ecto.Queryable.t(), map()) :: {:ok, {list, page_info}} | {:error, atom}
  def paginate(query, params) do
    with {:ok, params} <- check_pagination_methods(params) do
      do_paginate(query, params)
    end
  end

  defp check_pagination_methods(params) do
    {methods, _} = Map.split(params, ~w(page offset))

    if Enum.count(methods) <= 1 do
      {:ok, params}
    else
      {:error, :bad_request}
    end
  end

  defp do_paginate(query, %{"page" => page} = params) when is_binary(page) do
    with {:ok, page} <- parse_integer(page),
         {:ok, page_size} <- parse_integer(params["limit"], @default_page_size),
         {list, meta} <- Flop.validate_and_run!(query, %Flop{page: page, page_size: page_size}) do
      {:ok,
       {list,
        %{
          count: meta.total_count,
          next: if(meta.next_page, do: {:page, meta.next_page}),
          previous: if(meta.previous_page, do: {:page, meta.previous_page})
        }}}
    end
  end

  defp do_paginate(query, %{"offset" => offset} = params) when is_binary(offset) do
    with {:ok, offset} <- parse_integer(offset),
         {:ok, limit} <- parse_integer(params["limit"], @default_page_size),
         {list, meta} <- Flop.validate_and_run!(query, %Flop{offset: offset, limit: limit}) do
      {:ok,
       {list,
        %{
          count: meta.total_count,
          next: if(meta.next_offset, do: {:offset, meta.next_offset}),
          previous: if(meta.previous_offset, do: {:offset, meta.previous_offset})
        }}}
    end
  end

  defp do_paginate(query, params), do: do_paginate(query, Map.put(params, "page", "1"))

  defp parse_integer(value) do
    case Integer.parse(value) do
      :error -> {:error, :bad_request}
      {value, _} -> {:ok, value}
    end
  end

  defp parse_integer(value, default_value) do
    if value do
      parse_integer(value)
    else
      {:ok, default_value}
    end
  end
end
