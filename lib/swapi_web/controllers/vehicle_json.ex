defmodule SWAPIWeb.VehicleJSON do
  alias SWAPI.Schemas.Vehicle
  alias SWAPI.Schemas.Transport

  use Phoenix.VerifiedRoutes, endpoint: SWAPIWeb.Endpoint, router: SWAPIWeb.Router

  @doc """
  Renders a list of vehicles.
  """
  def index(%{vehicles: vehicles}) do
    %{data: for(vehicle <- vehicles, do: data(vehicle))}
  end

  @doc """
  Renders a single vehicle.
  """
  def show(%{vehicle: vehicle}) do
    %{data: data(vehicle)}
  end

  defp data(%Vehicle{transport: %Transport{} = transport} = vehicle) do
    %{
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
