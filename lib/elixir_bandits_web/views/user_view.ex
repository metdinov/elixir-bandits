defmodule ElixirBanditsWeb.UserView do
  use ElixirBanditsWeb, :view
  alias ElixirBanditsWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    # TODO: fix user view, add total score
    %{username: user.username, password: user.password}
  end

  def render("create.json", %{user: user}) do
    %{created: DateTime.utc_now(), username: user.username}
  end
end
