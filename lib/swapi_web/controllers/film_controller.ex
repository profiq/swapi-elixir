defmodule SWAPIWeb.FilmController do
  use SWAPIWeb, :controller

  alias SWAPI.Films

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {films, meta}} <- Films.search_films(query, params) do
      render(conn, :index, films: films, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {films, meta}} <- Films.list_films(params) do
      render(conn, :index, films: films, meta: meta)
    end
  end

  def show(conn, %{"id" => id}) do
    film = Films.get_film!(id)
    render(conn, :show, film: film)
  end
end
