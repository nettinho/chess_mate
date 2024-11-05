defmodule ChessMateWeb.Router do
  use ChessMateWeb, :router

  import ChessMateWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ChessMateWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:chess_mate, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    # import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      # live_dashboard "/dashboard", metrics: ChessMateWeb.Telemetry
      # forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ChessMateWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ChessMateWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", ChessMateWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ChessMateWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end

    live_session :require_authenticated_roled_user,
      on_mount: [{ChessMateWeb.UserAuth, :ensure_roled_authenticated}] do
      live "/playbook/:team_id/:round_id", PlaybookLive.Round
      live "/playbook/next", PlaybookLive.NextRound
    end

    live_session :require_authenticated_admin_user,
      on_mount: [{ChessMateWeb.UserAuth, :ensure_admin_authenticated}] do
      live "/scrap", ScrapLive.Index

      live "/user_roles", UserRoleLive.Index, :index
      live "/user_roles/new", UserRoleLive.Index, :new
      live "/user_roles/:id/edit", UserRoleLive.Index, :edit
      live "/user_roles/:id", UserRoleLive.Show, :show
      live "/user_roles/:id/show/edit", UserRoleLive.Show, :edit

      live "/users", UserLive.Index, :index
      live "/users/:id/edit", UserLive.Index, :edit
      live "/users/:id", UserLive.Show, :show
      live "/users/:id/show/edit", UserLive.Show, :edit
    end
  end

  scope "/", ChessMateWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{ChessMateWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new

      live "/", HomeLive
      live "/tournments", TournmentsLive.Index
      live "/tournments/:id", TournmentsLive.Show

      live "/teams/:id", TeamsLive.Show

      live "/teams/players/:id", TeamsLive.Player
    end
  end
end
