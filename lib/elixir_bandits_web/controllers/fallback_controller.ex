defmodule ElixirBanditsWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ElixirBanditsWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ElixirBanditsWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, invalid_bandit}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ElixirBanditsWeb.ErrorView)
    |> render(:"400")
  end
end
