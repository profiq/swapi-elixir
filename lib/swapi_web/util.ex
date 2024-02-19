defmodule SWAPIWeb.Util do
  @moduledoc """
  Utility functions for the SWAPI web app
  """

  alias SWAPIWeb.Endpoint

  def page_url(_conn, nil), do: nil

  def page_url(conn, {param, value}) do
    query_string =
      conn.query_params
      |> Map.put(Atom.to_string(param), value)
      |> URI.encode_query()

    Endpoint.url()
    |> URI.parse()
    |> URI.append_path(conn.request_path)
    |> URI.append_query(query_string)
    |> URI.to_string()
  end

  def parse_search_query(query) do
    ~r/"([^"]+)"|([^\s,"]+)/
    |> Regex.scan(query)
    |> Enum.map(&List.last/1)
  end
end
