defmodule SWAPIWeb.VehicleController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OpenApiSpex.Schema
  alias SWAPI.Vehicles

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  tags(["vehicles"])

  operation(:index,
    summary: "Get all vehicle resources",
    parameters: [
      search: [
        in: :query,
        description:
          "One or more search terms, which should be whitespace and/or comma separated. If multiple search terms are used then objects will be returned in the list only if all the provided terms are matched. Searches may contain quoted phrases with spaces, each phrase is considered as a single search term.",
        type: :string
      ],
      page: [
        in: :query,
        description: "Page number. Cannot be used together with `offset`.",
        schema: %Schema{
          type: :integer,
          minimum: 1,
          default: 1
        }
      ],
      offset: [
        in: :query,
        description: "Offset of the first item. Cannot be used together with `page`.",
        schema: %Schema{
          type: :integer,
          minimum: 0
        }
      ],
      limit: [
        in: :query,
        description: "Maximum number of items to return in the response.",
        schema: %Schema{
          type: :integer,
          minimum: 1,
          default: 10
        }
      ]
    ],
    responses: [
      ok: {"List of vehicles", "application/json", SWAPIWeb.Schemas.VehicleList}
    ]
  )

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {vehicles, meta}} <- Vehicles.search_vehicles(query, params) do
      render(conn, :index, vehicles: Vehicles.preload_all(vehicles), meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {vehicles, meta}} <- Vehicles.list_vehicles(params) do
      render(conn, :index, vehicles: Vehicles.preload_all(vehicles), meta: meta)
    end
  end

  operation(:show,
    summary: "Get a specific vehicle resource",
    parameters: [
      id: [in: :path, description: "Vehicle ID", type: :integer]
    ],
    responses: [
      ok: {"A vehicle", "application/json", SWAPIWeb.Schemas.Vehicle}
    ]
  )

  def show(conn, %{"id" => id}) do
    with {:ok, vehicle} <- Vehicles.get_vehicle(id) do
      render(conn, :show, vehicle: Vehicles.preload_all(vehicle))
    end
  end
end
