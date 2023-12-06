defmodule SWAPIWeb.RootController do
  use SWAPIWeb, :controller

  action_fallback SWAPIWeb.FallbackController

  def index(conn, _params) do
    render(conn, :index)
  end
end
