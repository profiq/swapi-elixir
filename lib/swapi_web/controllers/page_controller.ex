defmodule SWAPIWeb.PageController do
  use SWAPIWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
