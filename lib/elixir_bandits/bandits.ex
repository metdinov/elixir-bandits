defmodule ElixirBandits.Bandit do
  @moduledoc """
  Bandit logic module
  """

  def get_payoff(:a) do
    {:ok, Enum.random(100..1000)}
  end

  def get_payoff(:b) do
    {:ok, Enum.random(1..100)}
  end

  def get_payoff(invalid) do
    {:error, invalid}
  end

  def list_bandits do
    "pass"
  end
end
