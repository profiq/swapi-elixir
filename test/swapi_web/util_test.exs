defmodule SWAPIWeb.UtilTest do
  use ExUnit.Case, async: true

  alias SWAPIWeb.Endpoint

  describe "page_url/2" do
    test "returns nil if page_number is nil" do
      assert SWAPIWeb.Util.page_url(%Plug.Conn{}, nil) == nil
    end

    test "returns a URL with the page number" do
      conn = %Plug.Conn{request_path: "/films", query_params: %{"page" => 1}}
      assert SWAPIWeb.Util.page_url(conn, {:page, 2}) == "#{Endpoint.url()}/films?page=2"
    end

    test "returns a URL with the offset number" do
      conn = %Plug.Conn{request_path: "/films", query_params: %{"offset" => 1}}
      assert SWAPIWeb.Util.page_url(conn, {:offset, 2}) == "#{Endpoint.url()}/films?offset=2"
    end
  end

  describe "parse_search_query/1" do
    test "parses a space-separated search query" do
      assert SWAPIWeb.Util.parse_search_query("foo bar") == ["foo", "bar"]
    end

    test "parses a comma-separated search query" do
      assert SWAPIWeb.Util.parse_search_query("foo,bar") == ["foo", "bar"]
    end

    test "parses a quoted search term" do
      assert SWAPIWeb.Util.parse_search_query("\"foo bar\"") == ["foo bar"]
    end

    test "parses a quoted search term with a comma" do
      assert SWAPIWeb.Util.parse_search_query("\"foo, bar\"") == ["foo, bar"]
    end

    test "handles both quoted and unquoted search terms" do
      assert SWAPIWeb.Util.parse_search_query("\"foo bar\" baz") == ["foo bar", "baz"]
    end
  end
end
