defmodule SWAPIWeb.PersonController do
  use SWAPIWeb, :controller

  alias SWAPI.People

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query) |> IO.inspect()

    with {:ok, {people, meta}} <- People.search_people(query, params) do
      render(conn, :index, people: people, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {people, meta}} <- People.list_people(params) do
      render(conn, :index, people: people, meta: meta)
    end
  end

  def show(conn, %{"id" => id}) do
    person = People.get_person!(id)
    render(conn, :show, person: person)
  end
end
