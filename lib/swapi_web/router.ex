defmodule SWAPIWeb.Router do
  use SWAPIWeb, :router

  alias SWAPIWeb.{
    PageController,
    RootController,
    PersonController,
    FilmController,
    StarshipController,
    VehicleController,
    SpeciesController,
    PlanetController
  }

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: SWAPIWeb.ApiSpec
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SWAPIWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :browser

    get "/", PageController, :home
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
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
end
