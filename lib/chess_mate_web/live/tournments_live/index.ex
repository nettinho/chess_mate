defmodule ChessMateWeb.TournmentsLive.Index do
  use ChessMateWeb, :live_view

  alias ChessMate.Roster

  def mount(_params, _session, socket) do
    tournments = Roster.list_tournments()

    {:ok,
     assign(socket,
       tournments: tournments
     )}
  end
end
