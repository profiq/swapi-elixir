defmodule SWAPIWeb.PersonController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OpenApiSpex.Schema
  alias SWAPI.People

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  tags(["people"])

  operation(:index,
    summary: "Get all people resources",
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
      ],
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
      ok: {"List of people", "application/json", SWAPIWeb.Schemas.PersonList}
    ]
  )

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {people, meta}} <- People.search_people(query, params) do
      render(conn, :index, people: people, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {people, meta}} <- People.list_people(params) do
      render(conn, :index, people: people, meta: meta)
    end
  end

  operation(:show,
    summary: "Get a specific people resource",
    parameters: [
      id: [in: :path, description: "Person ID", type: :integer],
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
      ok: {"A person", "application/json", SWAPIWeb.Schemas.Person}
    ]
  )

  def show(conn, %{"id" => id}) do
    with {:ok, person} <- People.get_person(id) do
      render(conn, :show, person: person)
    end
  end
end
