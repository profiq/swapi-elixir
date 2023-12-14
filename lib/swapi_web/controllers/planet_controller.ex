defmodule SWAPIWeb.PlanetController do
  use SWAPIWeb, :controller

  alias SWAPI.Planets

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {planets, meta}} <- Planets.search_planets(query, params) do
      render(conn, :index, planets: planets, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {planets, meta}} <- Planets.list_planets(params) do
      render(conn, :index, planets: planets, meta: meta)
    end
  end

  def show(conn, %{"id" => id}) do
    planet = Planets.get_planet!(id)
    render(conn, :show, planet: planet)
  end
end
