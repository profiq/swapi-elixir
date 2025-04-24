defmodule SWAPIWeb.WookieeEncoder do
  @moduledoc """
  This module handles wookie encoding for the REST API.
  """

  import Plug.Conn

  @behaviour Plug

  @map %{
    ?a => ~c"ra",
    ?b => ~c"rh",
    ?c => ~c"oa",
    ?d => ~c"wa",
    ?e => ~c"wo",
    ?f => ~c"ww",
    ?g => ~c"rr",
    ?h => ~c"ac",
    ?i => ~c"ah",
    ?j => ~c"sh",
    ?k => ~c"or",
    ?l => ~c"an",
    ?m => ~c"sc",
    ?n => ~c"wh",
    ?o => ~c"oo",
    ?p => ~c"ak",
    ?q => ~c"rq",
    ?r => ~c"rc",
    ?s => ~c"c",
    ?t => ~c"ao",
    ?u => ~c"hu",
    ?v => ~c"ho",
    ?w => ~c"oh",
    ?x => ~c"k",
    ?y => ~c"ro",
    ?z => ~c"uf"
  }

  @spec translate_to_wookiee(String.t()) :: String.t()
  def translate_to_wookiee(text) do
    text
    |> String.to_charlist()
    |> Enum.reverse()
    |> Enum.reduce(~c"", fn char, acc ->
      case @map[char] do
        nil -> [char | acc]
        value -> value ++ acc
      end
    end)
    |> to_string()
  end

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  def call(%{query_params: %{"format" => "wookiee"}} = conn, _opts) do
    register_before_send(conn, &before_send_callback/1)
  end

  def call(conn, _opts), do: conn

  @spec before_send_callback(Plug.Conn.t()) :: Plug.Conn.t()
  defp before_send_callback(%{status: 200} = conn) do
    wookie_body =
      conn.resp_body
      |> IO.iodata_to_binary()
      |> translate_to_wookiee()

    resp(conn, conn.status, wookie_body)
  end

  defp before_send_callback(conn), do: conn
end
