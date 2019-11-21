defmodule ElixirBandits.Auth.Token do
  @moduledoc false

  defstruct [:access_token, :expires_in, :token_type, :scope]

  alias Walle.Auth.Guardian.Plug, as: SessionManager
  alias Wallex.Accounts.User

  ## API

  @doc false
  def new(conn, %User{} = user, claims \\ %{}) do
    conn = SessionManager.sign_in(conn, user, claims)
    jwt = SessionManager.current_token(conn)
    claims = SessionManager.current_claims(conn)

    %Wallex.Accounts.Auth.Token{
      access_token: jwt,
      expires_in: expiry_time(claims["exp"]),
      token_type: "Bearer",
      scope: user.type
    }
  end

  ## Private Functions

  defp expiry_time(expire_at) do
    expire_at - DateTime.to_unix(DateTime.utc_now())
  end
end
