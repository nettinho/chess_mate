defmodule ChessMateWeb.UserLoginLive do
  use ChessMateWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center mb-10">
        <%= gettext("Inicia sesión") %>
        <:subtitle>
          <%= gettext("¿No tienes una cuenta?") %>
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            <%= gettext("Apúntate") %>
          </.link>
          <%= gettext("para acceder.") %>
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label={gettext("Correo electrónico")} required />
        <.input field={@form[:password]} type="password" label={gettext("Contraseña")} required />

        <:actions>
          <.input
            field={@form[:remember_me]}
            type="checkbox"
            label={gettext("Mantener sesión iniciada")}
          />
          <.link
            href={~p"/users/reset_password"}
            class="text-sm font-semibold text-gray-900 dark:text-gray-300"
          >
            <%= gettext("¿Has olvidado tu contraseña?") %>
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full">
            <%= gettext("Entrar") %> <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
