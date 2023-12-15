defmodule SWAPIWeb.IndexController do
  use SWAPIWeb, :controller

  import Phoenix.VerifiedRoutes

  def index(conn, _params) do
    conn
    |> redirect(to: ~p"/swaggerui")
  end
end
