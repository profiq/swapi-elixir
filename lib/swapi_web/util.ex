defmodule SWAPIWeb.Util do
  alias SWAPIWeb.Endpoint

  def page_url(_conn, nil), do: nil

  def page_url(conn, page_number) do
    query_string =
      conn.query_params
      |> Map.put("page", page_number)
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
