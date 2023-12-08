defmodule SWAPIWeb.VehicleController do
  use SWAPIWeb, :controller

  alias SWAPI.Vehicles
  alias SWAPI.Schemas.Vehicle

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

  def create(conn, %{"vehicle" => vehicle_params}) do
    with {:ok, %Vehicle{} = vehicle} <- Vehicles.create_vehicle(vehicle_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/vehicles/#{vehicle}")
      |> render(:show, vehicle: vehicle)
    end
  end

  def show(conn, %{"id" => id}) do
    vehicle = Vehicles.get_vehicle!(id)
    render(conn, :show, vehicle: vehicle)
  end

  def update(conn, %{"id" => id, "vehicle" => vehicle_params}) do
    vehicle = Vehicles.get_vehicle!(id)

    with {:ok, %Vehicle{} = vehicle} <- Vehicles.update_vehicle(vehicle, vehicle_params) do
      render(conn, :show, vehicle: vehicle)
    end
  end

  def delete(conn, %{"id" => id}) do
    vehicle = Vehicles.get_vehicle!(id)

    with {:ok, %Vehicle{}} <- Vehicles.delete_vehicle(vehicle) do
      send_resp(conn, :no_content, "")
    end
  end
end
