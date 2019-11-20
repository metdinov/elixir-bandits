defmodule ElixirBanditsWeb.PageController do
  use ElixirBanditsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
