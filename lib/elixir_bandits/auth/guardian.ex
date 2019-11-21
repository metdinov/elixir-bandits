defmodule ElixirBandits.Auth.Guardian do
  use Guardian, otp_app: :elixir_bandits

  def subject_for_token(username, _claims) do
    {:ok, username}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    username = claims["sub"]
    ElixirBandits.Accounts.get_user(username)
  end

  def resource_from_claims(_claims) do
    {:error, :resource_not_found}
  end
end
