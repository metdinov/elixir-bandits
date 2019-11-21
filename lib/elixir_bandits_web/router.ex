defmodule ElixirBanditsWeb.Router do
  use ElixirBanditsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug :accepts, ["json"]
    plug(ElixirBandits.Auth.Pipeline)
  end

  scope "/", ElixirBanditsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", ElixirBanditsWeb do
    pipe_through :api_auth

    get "/bandit/:id", BanditController, :show
  end

  scope "/api", ElixirBanditsWeb do
    pipe_through :api

    # Auth
    post("/users/signup", UserController, :create)
    post("/users/signin", SessionController, :create) 
    post("/users/refresh", SessionController, :refresh)   
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirBanditsWeb do
  #   pipe_through :api
  # end
end
