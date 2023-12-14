defmodule SWAPIWeb.VehicleController do
  use SWAPIWeb, :controller

  alias SWAPI.Vehicles

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {vehicles, meta}} <- Vehicles.search_vehicles(query, params) do
      render(conn, :index, vehicles: vehicles, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {vehicles, meta}} <- Vehicles.list_vehicles(params) do
      render(conn, :index, vehicles: vehicles, meta: meta)
    end
  end

  def show(conn, %{"id" => id}) do
    vehicle = Vehicles.get_vehicle!(id)
    render(conn, :show, vehicle: vehicle)
  end
end
