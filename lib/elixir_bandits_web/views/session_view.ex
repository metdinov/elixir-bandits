defmodule ElixirBanditsWeb.SessionView do
    use ElixirBanditsWeb, :view
    alias ElixirBanditsWeb.SessionView
  
    def render("index.json", %{users: users}) do
      %{data: render_many(users, SessionView, "session.json")}
    end
  
    def render("show.json", %{user: user, jwt: jwt}) do
      %{success: "Successful login", username: user, jwt: jwt}
    end
  
    def render("user.json", %{user: user}) do
      %{username: user.username, password: user.password}
    end
  
    def render("create.json", %{user: username}) do
      %{success: DateTime.utc_now(), username: username}
    end

    def render("error.json", %{error: error}) do
      %{error: error}
    end

    def render("delete.json", _) do
        %{ok: true}
    end
end