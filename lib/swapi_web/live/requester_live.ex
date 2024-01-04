defmodule SWAPIWeb.RequesterLive do
  use SWAPIWeb, :live_view
  use SWAPIWeb, :verified_routes

  def render(assigns) do
    ~H"""
    <.form for={@form} phx-change="change" phx-submit="request">
      <div class="input-group">
        <span class="input-group-text"><%= url(~p"/api/") %></span>
        <.input type="text" class="form-control" field={@form[:url]} />
        <button class="btn btn-primary">&#x25B6;</button>
      </div>
    </.form>
    <%= if @result do %>
    <div class={"border rounded mt-2"}>
      <pre class="m-2"><%= @result %></pre>
    </div>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:form, to_form(%{"url" => ""}))
      |> assign(:result, nil),
      layout: false
    }
  end

  def handle_event("change", %{"url" => url}, socket) do
    {:noreply, assign(socket, :form, to_form(%{"url" => url}))}
  end

  def handle_event("request", %{"url" => url}, socket) do
    result =
      Phoenix.ConnTest.build_conn()
      |> Phoenix.ConnTest.dispatch(SWAPIWeb.Endpoint, :get, "/api/#{url}")
      |> Map.get(:resp_body)
      |> Jason.Formatter.pretty_print()

    {:noreply, assign(socket, :result, result)}
  end
end
