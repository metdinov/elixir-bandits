defmodule ElixirBanditsWeb.SessionChannel do
  use ElixirBanditsWeb, :channel

  alias ElixirBandits.Bandits

  def join("session:" <> _username, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @doc """
  Bandit Event Handler
  """
  def handle_in("bandit", %{"bandit_id" => bandit_id}, socket) do
    case Bandits.get_payoff(bandit_id, socket.assigns.token) do
      {:ok, payoff} -> {:reply, {:ok, %{bandit_id: bandit_id, payoff: payoff}}, socket}
      {:error, reason} -> {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
