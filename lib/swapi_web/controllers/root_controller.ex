defmodule SWAPIWeb.RootController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  action_fallback SWAPIWeb.FallbackController

  tags ["root"]

  operation :index,
    summary: "Get URL roots for all available resources",
    responses: [
      ok: {"List of endpoints", "application/json", SWAPIWeb.Schemas.Root}
    ]

  def index(conn, _params) do
    render(conn, :index)
  end
end
