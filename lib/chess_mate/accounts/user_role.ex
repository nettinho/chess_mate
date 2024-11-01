defmodule ChessMate.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  alias ChessMate.Accounts
  alias ChessMate.Accounts.User

  schema "user_roles" do
    field :role, :string
    field :team_prefix, :string

    belongs_to :user, User
    field :user_email, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def create_changeset(attrs) do
    changeset = cast(%__MODULE__{}, attrs, [:role, :team_prefix, :user_email])

    user =
      changeset
      |> get_field(:user_email, "")
      |> Accounts.get_user_by_email()

    changeset
    |> put_user(user)
    |> validate_required([:role, :team_prefix, :user_id])
  end

  defp put_user(changeset, %User{id: id}), do: put_change(changeset, :user_id, id)
  defp put_user(changeset, _), do: add_error(changeset, :user_email, "invalid email")

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:role, :team_prefix, :user_id])
    |> validate_required([:role, :team_prefix, :user_id])
  end
end
