defmodule SWAPIWeb.FilmController do
  use SWAPIWeb, :controller

  alias SWAPI.Films
  alias SWAPI.Schemas.Film

  action_fallback SWAPIWeb.FallbackController

  def index(conn, _params) do
    films = Films.list_films()
    render(conn, :index, films: films)
  end

  def create(conn, %{"film" => film_params}) do
    with {:ok, %Film{} = film} <- Films.create_film(film_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/films/#{film}")
      |> render(:show, film: film)
    end
  end

  def show(conn, %{"id" => id}) do
    film = Films.get_film!(id)
    render(conn, :show, film: film)
  end

  def update(conn, %{"id" => id, "film" => film_params}) do
    film = Films.get_film!(id)

    with {:ok, %Film{} = film} <- Films.update_film(film, film_params) do
      render(conn, :show, film: film)
    end
  end

  def delete(conn, %{"id" => id}) do
    film = Films.get_film!(id)

    with {:ok, %Film{}} <- Films.delete_film(film) do
      send_resp(conn, :no_content, "")
    end
  end
end
