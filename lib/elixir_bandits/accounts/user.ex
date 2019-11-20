defmodule ElixirBandits.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  embedded_schema do
    field(:password, :string)
    field(:username, :string)
    field(:password_hash, :string)
  end

  @doc false
  def changeset(user \\ %User{}, attrs \\ %{}) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> hash_password()
  end

  def process_changeset(changeset) do
    apply_action(changeset, :insert)
  end

  defp hash_password(changeset) do
    if changeset.valid? do
      put_change(
        changeset,
        :password_hash,
        Argon2.hash_pwd_salt(get_field(changeset, :password))
      )
    else
      changeset
    end
  end
end
