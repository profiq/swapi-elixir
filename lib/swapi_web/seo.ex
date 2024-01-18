defmodule SWAPIWeb.SEO do
  use SEO, [
    json_library: Jason,
    site: &__MODULE__.site_config/1,
    open_graph: SEO.OpenGraph.build(
      description: "The Star Wars API",
      site_name: "Elixir SWAPI",
      locale: "en_US"
    )
  ]

  def site_config(_conn) do
    SEO.Site.build(
      default_title: "SWAPI",
      description: "The Star Wars API",
      theme_color: "#FFEE00",
      windows_tile_color: "#FFEE00",
      mask_icon_color: "#FFEE00"
    )
  end
end
