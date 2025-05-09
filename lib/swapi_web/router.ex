defmodule SWAPIWeb.Router do
  use SWAPIWeb, :router

  alias SWAPIWeb.FilmController
  alias SWAPIWeb.PageController
  alias SWAPIWeb.PersonController
  alias SWAPIWeb.PlanetController
  alias SWAPIWeb.RootController
  alias SWAPIWeb.SpeciesController
  alias SWAPIWeb.StarshipController
  alias SWAPIWeb.VehicleController

  pipeline :api do
    plug :accepts, ["json"]

    plug :put_cache_control_header,
         "public, max-age=86400, s-max-age=172800, stale-while-revalidate=2678400"

    plug OpenApiSpex.Plug.PutApiSpec, module: SWAPIWeb.ApiSpec
    plug SWAPIWeb.WookieeEncoder
  end

  pipeline :graphql do
    plug :accepts, ["json", "graphql-response+json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug :put_cache_control_header,
         "public, max-age=86400, s-max-age=172800, stale-while-revalidate=2678400"
  end

  scope "/" do
    pipe_through :browser

    get "/", PageController, :home
    get "/postman", PageController, :postman
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"

    get "/graphiql", Absinthe.Plug.GraphiQL,
      schema: SWAPIWeb.GraphQL.Schema,
      default_url: "/api/graphql",
      interface: :playground
  end

  scope "/api" do
    pipe_through :api

    get "/", RootController, :index

    resources "/people", PersonController, only: [:index, :show]
    resources "/films", FilmController, only: [:index, :show]
    resources "/starships", StarshipController, only: [:index, :show]
    resources "/vehicles", VehicleController, only: [:index, :show]
    resources "/species", SpeciesController, only: [:index, :show]
    resources "/planets", PlanetController, only: [:index, :show]

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api/graphql" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: SWAPIWeb.GraphQL.Schema
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:swapi, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: SWAPIWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp put_cache_control_header(conn, value) do
    Plug.Conn.put_resp_header(conn, "cache-control", value)
  end
end
