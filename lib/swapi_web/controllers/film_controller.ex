defmodule SWAPIWeb.FilmController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OpenApiSpex.Schema
  alias SWAPI.Films

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  tags(["films"])

  operation(:index,
    summary: "Get all the film resources",
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
      ok: {"List of films", "application/json", SWAPIWeb.Schemas.FilmList}
    ]
  )

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {films, meta}} <- Films.search_films(query, params) do
      render(conn, :index, films: films, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {films, meta}} <- Films.list_films(params) do
      render(conn, :index, films: films, meta: meta)
    end
  end

  operation(:show,
    summary: "Get a specific film resource",
    parameters: [
      id: [in: :path, description: "Film ID", type: :integer]
    ],
    responses: [
      ok: {"A film", "application/json", SWAPIWeb.Schemas.Film}
    ]
  )

  def show(conn, %{"id" => id}) do
    with {:ok, film} <- Films.get_film(id) do
      render(conn, :show, film: film)
    end
  end
end
