defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  @impl true
  def join("game:" <> _id, payload, socket) do
    if authorized?(payload) do
      game = Bulls.Game.new()
      socket = assign(socket, :game, game)
      view = Bulls.Game.view(game)
      {:ok, view, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("guess", %{"guess" => ll}, socket) do
    game0 = socket.assigns[:game]
    game1 = Bulls.Game.guess(game0, ll)
    socket = assign(socket, :game, game1)
    view = Bulls.Game.view(game1)
    {:reply, {:ok, view}, socket}
  end

  # handle reset button
  @impl true
  def handle_in("reset", _, socket) do
    game = Bulls.Game.new()
    socket = assign(socket, :game, game)
    view = Bulls.Game.view(game)
    {:ok, view, socket}
  end
  
  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
