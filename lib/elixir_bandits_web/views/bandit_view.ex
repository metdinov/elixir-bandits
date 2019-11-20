defmodule ElixirBanditsWeb.BanditView do
  use ElixirBanditsWeb, :view
  alias ElixirBanditsWeb.BanditView

  def render("index.json", %{bandits: bandits}) do
    %{data: render_many(bandits, BanditView, "bandit.json")}
  end

  def render("bandit.json", %{bandit: bandit}) do
    %{id: bandit}
  end

  def render("show.json", %{payoff: payoff}) do
    %{payoff: payoff}
  end
end
