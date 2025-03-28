defmodule SWAPIWeb.RootController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OpenApiSpex.Schema

  action_fallback SWAPIWeb.FallbackController

  tags(["root"])

  operation(:index,
    summary: "Get URL roots for all available resources",
    parameters: [
      format: [
        in: :query,
        description: "Specifies the encoding to be used for the response",
        schema: %Schema{
          type: :string,
          default: "json",
          enum: ["json", "wookiee"]
        }
      ]
    ],
    responses: [
      ok: {"List of endpoints", "application/json", SWAPIWeb.Schemas.Root}
    ]
  )

  def index(conn, _params) do
    render(conn, :index)
  end
end
