defmodule SWAPIWeb.SEO do
  @moduledoc """
  SEO definitions
  """

  use SWAPIWeb, :verified_routes

  use SEO,
    json_library: Jason,
    site: &__MODULE__.site_config/1,
    open_graph:
      SEO.OpenGraph.build(
        description: "The Star Wars API",
        site_name: "Elixir SWAPI",
        locale: "en_US"
      )

  def site_config(_conn) do
    SEO.Site.build(
      default_title: "Elixir SWAPI",
      description: "The Star Wars API",
      theme_color: "#2b3035",
      windows_tile_color: "#2b3035",
      mask_icon_color: "#2b3035",
      mask_icon_url: url(~p"/safari-pinned-tab.svg"),
      manifest_url: url(~p"/site.webmanifest")
    )
  end
end
