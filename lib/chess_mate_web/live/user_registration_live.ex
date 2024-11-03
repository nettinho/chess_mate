defmodule ChessMateWeb.UserRegistrationLive do
  use ChessMateWeb, :live_view

  alias ChessMate.Accounts
  alias ChessMate.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center mb-10">
        <%= gettext("Crear una cuenta") %>
        <:subtitle>
          <%= gettext("¿Ya tienes una cuenta?") %>
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            <%= gettext("Inicia sesión") %>
          </.link>

          <%= gettext("para continuar.") %>
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          <%= gettext("Ups, algo ha ido mal. Verifica los errores abajo.") %>
        </.error>

        <.input field={@form[:email]} type="email" label={gettext("Correo electrónico")} required />
        <.input field={@form[:password]} type="password" label={gettext("Contraseña")} required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">
            <%= gettext("Crear una cuenta") %>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
