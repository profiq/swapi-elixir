defmodule SWAPIWeb.ErrorJSONTest do
  use SWAPIWeb.ConnCase, async: true

  test "renders 404" do
    assert SWAPIWeb.ErrorJSON.render("404.json", %{}) == %{detail: "Not Found"}
  end

  test "renders 500" do
    assert SWAPIWeb.ErrorJSON.render("500.json", %{}) ==
             %{detail: "Internal Server Error"}
  end
end
