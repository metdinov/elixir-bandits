defmodule ElixirBandits.Bandit do
  @moduledoc """
  Bandit logic module
  """
  alias ElixirBandits.Registry

  def get_payoff(:a, session_id) do
    payoff = Enum.random(100..1000)
    {:ok, _, _} = Registry.insert_score(session_id, {:a, payoff})
    {:ok, payoff}
  end

  def get_payoff(:b, session_id) do
    payoff = Enum.random(1..100)
    {:ok, _, _} = Registry.insert_score(session_id, {:b, payoff})
    {:ok, payoff}
  end

  def get_payoff(invalid) do
    {:error, "Bandit #{invalid} not found"}
  end

  def list_bandits do
    "pass"
  end
end
