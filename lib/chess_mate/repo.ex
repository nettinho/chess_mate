defmodule ChessMate.Repo do
  use Ecto.Repo,
    otp_app: :chess_mate,
    adapter: Ecto.Adapters.Postgres
end
