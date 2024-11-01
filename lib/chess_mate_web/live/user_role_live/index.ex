defmodule ChessMateWeb.UserRoleLive.Index do
  use ChessMateWeb, :live_view

  alias ChessMate.Accounts
  alias ChessMate.Accounts.UserRole

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :user_roles, Accounts.list_user_roles(preload: [:user]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User role")
    |> assign(:user_role, Accounts.get_user_role!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User role")
    |> assign(:user_role, %UserRole{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User roles")
    |> assign(:user_role, nil)
  end

  @impl true
  def handle_info({ChessMateWeb.UserRoleLive.FormComponent, {:saved, user_role}}, socket) do
    {:noreply, stream_insert(socket, :user_roles, user_role)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_role = Accounts.get_user_role!(id)
    {:ok, _} = Accounts.delete_user_role(user_role)

    {:noreply, stream_delete(socket, :user_roles, user_role)}
  end
end
