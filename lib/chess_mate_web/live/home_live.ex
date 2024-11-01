defmodule ChessMateWeb.HomeLive do
  use ChessMateWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Chess Mate
    </.header>
    """
  end
end
