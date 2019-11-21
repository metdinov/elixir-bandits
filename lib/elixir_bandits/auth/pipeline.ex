defmodule ElixirBandits.Auth.Pipeline do
    use Guardian.Plug.Pipeline,
      otp_app: :elixir_bandits,
      module: ElixirBandits.Auth.Guardian,
      error_handler: ElixirBandits.Auth.ErrorHandler
  
    plug(Guardian.Plug.VerifyHeader)
    plug(Guardian.Plug.EnsureAuthenticated)
    #plug(Guardian.Plug.LoadResource)
end
  