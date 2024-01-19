defmodule SWAPIWeb.VehicleJSON do
  use SWAPIWeb, :verified_routes

  alias SWAPI.Schemas.Vehicle
  alias SWAPI.Schemas.Transport

  import SWAPIWeb.Util

  @doc """
  Renders a list of vehicles.
  """
  def index(%{vehicles: vehicles, meta: meta, conn: conn}) do
    %{
      count: meta.count,
      next: page_url(conn, meta.next),
      previous: page_url(conn, meta.previous),
      results: for(vehicle <- vehicles, do: data(vehicle))
    }
  end

  @doc """
  Renders a single vehicle.
  """
  def show(%{vehicle: vehicle}), do: data(vehicle)

  defp data(%Vehicle{transport: %Transport{} = transport} = vehicle) do
    %{
      id: transport.id,
      name: transport.name,
      model: transport.model,
      vehicle_class: vehicle.vehicle_class,
      manufacturer: transport.manufacturer,
      cost_in_credits: transport.cost_in_credits,
      length: transport.length,
      crew: transport.crew,
      passengers: transport.passengers,
      max_atmosphering_speed: transport.max_atmosphering_speed,
      cargo_capacity: transport.cargo_capacity,
      consumables: transport.consumables,
      films: for(film <- vehicle.films, do: url(~p"/api/films/#{film.id}")),
      pilots: for(pilot <- vehicle.pilots, do: url(~p"/api/people/#{pilot.id}")),
      url: url(~p"/api/vehicles/#{vehicle.id}"),
      created: transport.created,
      edited: transport.edited
    }
  end
end
