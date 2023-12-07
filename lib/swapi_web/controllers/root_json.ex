defmodule SWAPIWeb.RootJSON do
  use Phoenix.VerifiedRoutes, endpoint: SWAPIWeb.Endpoint, router: SWAPIWeb.Router

  @doc """
  Renders a list of available resources.
  """
  def index(_) do
    %{
      films: url(~p"/api/films"),
      people: url(~p"/api/people"),
      planets: url(~p"/api/planets"),
      species: url(~p"/api/species"),
      starships: url(~p"/api/starships"),
      vehicles: url(~p"/api/vehicles")
    }
  end
end
