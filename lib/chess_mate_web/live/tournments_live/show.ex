defmodule ChessMateWeb.TournmentsLive.Show do
  use ChessMateWeb, :live_view
  use LiveFlop

  alias ChessMateWeb.AppLiveFlop
  alias ChessMate.Roster
  alias ChessMate.Roster.Team

  def mount(%{"id" => id}, _session, socket) do
    tournment = Roster.get_tournment!(id)

    flop_assigns =
      AppLiveFlop.mount_assigns(~p"/tournments/#{tournment}", Team,
        query: Roster.team_query(tournment_id: tournment.id)
      )

    {:ok,
     socket
     |> assign(tournment: tournment)
     |> assign(flop_assigns)}
  end

  def handle_params(params, _, socket) do
    flop_assigns = LiveFlop.fetch_assigns(socket, params)

    {:noreply, assign(socket, flop_assigns)}
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

  defp rank_icon(%{team: %{initial_rank: initial, current_rank: current}} = assigns)
       when initial > current,
       do: ~H"""
       <.icon name="hero-arrow-up" class="text-green-500 dark:text-green-700 w-3 h-3 mr-0.5" />
       """

  defp rank_icon(%{team: %{initial_rank: initial, current_rank: current}} = assigns)
       when initial < current,
       do: ~H"""
       <.icon name="hero-arrow-down" class="text-red-500 dark:text-red-700 w-3 h-3 mr-0.5" />
       """

  defp rank_icon(assigns),
    do: ~H"""
    <.icon name="hero-minus" class="text-yellow-500 dark:text-yellow-700 w-3 h-3 mr-0.5" />
    """
end
