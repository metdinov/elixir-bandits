defmodule ElixirBanditsWeb.BanditController do
  use ElixirBanditsWeb, :controller

  alias ElixirBandits.Bandit

  action_fallback ElixirBanditsWeb.FallbackController

  def index(conn, _params) do
    bandit = Bandit.list_bandits()
    render(conn, "index.json", bandit: bandit)
  end

  def show(conn, %{"id" => bandit_id}) do
    with {:ok, payoff} <- Bandit.get_payoff(bandit_id, conn.session_id) do
      render(conn, "show.json", payoff: payoff)
    end
  end
end
