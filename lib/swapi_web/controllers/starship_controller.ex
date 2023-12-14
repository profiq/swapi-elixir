defmodule SWAPIWeb.StarshipController do
  use SWAPIWeb, :controller

  alias SWAPI.Starships

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {starships, meta}} <- Starships.search_starships(query, params) do
      render(conn, :index, starships: starships, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {starships, meta}} <- Starships.list_starships(params) do
      render(conn, :index, starships: starships, meta: meta)
    end
  end

  def show(conn, %{"id" => id}) do
    starship = Starships.get_starship!(id)
    render(conn, :show, starship: starship)
  end
end
