defmodule ChessMateWeb.TournmentsLive.Show do
  use ChessMateWeb, :live_view

  alias ChessMate.Roster

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       tournment: nil,
       teams: [],
       filter: ""
     )}
  end

  def handle_params(%{"id" => id}, _, socket) do
    tournment = Roster.get_tournment!(id)

    {:noreply,
     assign(socket,
       tournment: tournment,
       teams: tournment.teams
     )}
  end

  def handle_event("filter", %{"team" => filter}, socket) do
    teams =
      socket.assigns
      |> Map.get(:tournment)
      |> Map.get(:teams)
      |> Enum.filter(
        &String.contains?(
          String.downcase(&1.name),
          String.downcase(filter)
        )
      )

    {:noreply,
     assign(socket,
       filter: filter,
       teams: teams
     )}
  end
end
