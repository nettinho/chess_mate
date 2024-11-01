defmodule ChessMateWeb.UserRoleLive.FormComponent do
  use ChessMateWeb, :live_component

  alias ChessMate.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="user_role-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input :if={@action == :new} field={@form[:user_email]} type="text" label="Email" />
        <.input field={@form[:role]} type="select" label="Role" options={[{"Gestor", "manager"}]} />
        <.input field={@form[:team_prefix]} type="text" label="Team prefix" />
        <:actions>
          <.button phx-disable-with="Saving...">Save User role</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user_role: user_role} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Accounts.change_user_role(user_role))
     end)}
  end

  @impl true
  def handle_event("validate", %{"user_role" => user_role_params}, socket) do
    changeset =
      Accounts.change_user_role(socket.assigns.user_role, user_role_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"user_role" => user_role_params}, socket) do
    save_user_role(socket, socket.assigns.action, user_role_params)
  end

  defp save_user_role(socket, :edit, user_role_params) do
    case Accounts.update_user_role(socket.assigns.user_role, user_role_params, preload: [:user]) do
      {:ok, user_role} ->
        notify_parent({:saved, user_role})

        {:noreply,
         socket
         |> put_flash(:info, "User role updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_user_role(socket, :new, user_role_params) do
    case Accounts.create_user_role(user_role_params, preload: [:user]) do
      {:ok, user_role} ->
        notify_parent({:saved, user_role})

        {:noreply,
         socket
         |> put_flash(:info, "User role created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
