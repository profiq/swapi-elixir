defmodule SWAPIWeb.Router do
  use SWAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SWAPIWeb do
    pipe_through :api

    get "/", RootController, :index

    resources "/people", PersonController, except: [:new, :edit]
    resources "/films", FilmController, except: [:new, :edit]
    resources "/starships", StarshipController, except: [:new, :edit]
    resources "/vehicles", VehicleController, except: [:new, :edit]
    resources "/species", SpeciesController, except: [:new, :edit]
    resources "/planets", PlanetController, except: [:new, :edit]
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
