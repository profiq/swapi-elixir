defmodule SWAPIWeb.PlanetController do
  use SWAPIWeb, :controller

  alias SWAPI.Planets
  alias SWAPI.Schemas.Planet

  action_fallback SWAPIWeb.FallbackController

  def index(conn, _params) do
    planets = Planets.list_planets()
    render(conn, :index, planets: planets)
  end

  def create(conn, %{"planet" => planet_params}) do
    with {:ok, %Planet{} = planet} <- Planets.create_planet(planet_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/planets/#{planet}")
      |> render(:show, planet: planet)
    end
  end

  def show(conn, %{"id" => id}) do
    planet = Planets.get_planet!(id)
    render(conn, :show, planet: planet)
  end

  def update(conn, %{"id" => id, "planet" => planet_params}) do
    planet = Planets.get_planet!(id)

    with {:ok, %Planet{} = planet} <- Planets.update_planet(planet, planet_params) do
      render(conn, :show, planet: planet)
    end
  end

  def delete(conn, %{"id" => id}) do
    planet = Planets.get_planet!(id)

    with {:ok, %Planet{}} <- Planets.delete_planet(planet) do
      send_resp(conn, :no_content, "")
    end
  end
end
