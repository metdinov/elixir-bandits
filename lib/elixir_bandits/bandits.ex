defmodule ElixirBandits.Bandits do
  @moduledoc """
  Bandits logic module
  """
  alias ElixirBandits.Registry

  def get_payoff("a", session_id) do
    payoff = Enum.random(100..1000)
    Registry.insert_score(session_id, {:a, payoff})
    {:ok, payoff}
  end

  def get_payoff("b", session_id) do
    payoff = Enum.random(1..100)
    Registry.insert_score(session_id, {:b, payoff})
    {:ok, payoff}
  end

  def get_payoff(invalid, _sessinon_id) do
    {:error, "Bandit #{invalid} not found"}
  end

  def list_bandits do
    "pass"
  end
end
