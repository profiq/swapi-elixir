defmodule SWAPIWeb.StarshipController do
  use SWAPIWeb, :controller

  alias SWAPI.Starships
  alias SWAPI.Schemas.Starship

  action_fallback SWAPIWeb.FallbackController

  def index(conn, params) do
    with {:ok, {starships, meta}} <- Starships.list_starships(params) do
      render(conn, :index, starships: starships, meta: meta)
    end
  end

  def create(conn, %{"starship" => starship_params}) do
    with {:ok, %Starship{} = starship} <- Starships.create_starship(starship_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/starships/#{starship}")
      |> render(:show, starship: starship)
    end
  end

  def show(conn, %{"id" => id}) do
    starship = Starships.get_starship!(id)
    render(conn, :show, starship: starship)
  end

  def update(conn, %{"id" => id, "starship" => starship_params}) do
    starship = Starships.get_starship!(id)

    with {:ok, %Starship{} = starship} <- Starships.update_starship(starship, starship_params) do
      render(conn, :show, starship: starship)
    end
  end

  def delete(conn, %{"id" => id}) do
    starship = Starships.get_starship!(id)

    with {:ok, %Starship{}} <- Starships.delete_starship(starship) do
      send_resp(conn, :no_content, "")
    end
  end
end
