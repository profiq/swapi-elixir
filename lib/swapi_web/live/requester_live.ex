defmodule SWAPIWeb.RequesterLive do
  use SWAPIWeb, :live_view
  use SWAPIWeb, :verified_routes

  def render(assigns) do
    ~H"""
    <.form for={@form} phx-change="change" phx-submit="request">
      <div class="input-group">
        <span class="input-group-text" id="baseUrl"><%= url(~p"/api/") %></span>
        <.input type="text" class="form-control" field={@form[:url]} placeholder={@placeholder} />
        <button
          class="btn btn-link border d-flex align-items-center"
          title="Copy URL"
          onclick="copyRequestBoxUrl(); return false;"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="icon icon-tabler icon-tabler-copy"
            width="20"
            height="20"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path stroke="none" d="M0 0h24v24H0z" fill="none" />
            <path d="M7 7m0 2.667a2.667 2.667 0 0 1 2.667 -2.667h8.666a2.667 2.667 0 0 1 2.667 2.667v8.666a2.667 2.667 0 0 1 -2.667 2.667h-8.666a2.667 2.667 0 0 1 -2.667 -2.667z" />
            <path d="M4.012 16.737a2.005 2.005 0 0 1 -1.012 -1.737v-10c0 -1.1 .9 -2 2 -2h10c.75 0 1.158 .385 1.5 1" />
          </svg>
        </button>
        <button class="btn btn-primary d-flex align-items-center">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="icon icon-tabler icon-tabler-player-play-filled"
            width="16"
            height="16"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="#2c3e50"
            fill="none"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path stroke="none" d="M0 0h24v24H0z" fill="none" />
            <path
              d="M6 4v16a1 1 0 0 0 1.524 .852l13 -8a1 1 0 0 0 0 -1.704l-13 -8a1 1 0 0 0 -1.524 .852z"
              stroke-width="0"
              fill="currentColor"
            />
          </svg>
        </button>
      </div>
    </.form>
    <%= if @result do %>
      <div class="border rounded mt-2">
        <%= @result
        |> Makeup.highlight(
          lexer: Makeup.Lexers.JsonLexer,
          formatter_options: [css_class: "highlight p-2 m-0"]
        )
        |> raw() %>
      </div>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:form, to_form(%{"url" => ""}))
      |> assign(:placeholder, "people/1")
      |> assign(:result, nil),
      layout: false
    }
  end

  def handle_event("change", %{"url" => url}, socket) do
    {:noreply, assign(socket, :form, to_form(%{"url" => url}))}
  end

  def handle_event("request", %{"url" => ""}, socket) do
    {
      :noreply,
      socket
      |> assign(:form, to_form(%{"url" => socket.assigns.placeholder}))
      |> assign(:result, dispatch(socket.assigns.placeholder))
    }
  end

  def handle_event("request", %{"url" => url}, socket) do
    {:noreply, assign(socket, :result, dispatch(url))}
  end

  defp dispatch(url) do
    Phoenix.ConnTest.build_conn()
    |> Phoenix.ConnTest.dispatch(SWAPIWeb.Endpoint, :get, "/api/#{url}")
    |> Map.get(:resp_body)
    |> Jason.Formatter.pretty_print()
  end
end
