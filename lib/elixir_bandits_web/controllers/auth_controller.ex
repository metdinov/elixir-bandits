defmodule ElixirBanditsWeb.AuthController do
  use ElixirBanditsWeb, :controller

  alias ElixirBandits.Bandit
  alias ElixirBandits.Accounts.User

  action_fallback ElixirBanditsWeb.FallbackController

  def signup(conn, %{"user" => user_params}) do
    changeset = Accounts.change_user(%User{}, user_params)

    cond do
      not changeset.valid? ->
        {:error, changeset}

      Accounts.get_user_by(username: Changeset.get_field(changeset, :username)) ->
        changeset = Changeset.add_error(changeset, :username, "has already been taken")
        {:error, changeset}

      true ->
        otp =
          changeset
          |> Changeset.get_field(:username)
          |> OTP.new()
          |> OTP.send()

        conn
        |> put_view(WallexWeb.OTPView)
        |> render("token.json", token: otp)
    end
  end
end
