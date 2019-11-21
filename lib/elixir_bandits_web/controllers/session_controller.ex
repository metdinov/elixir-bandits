defmodule ElixirBanditsWeb.SessionController do
    use ElixirBanditsWeb, :controller
  
    alias ElixirBandits.Accounts
    alias ElixirBandits.Accounts.User
    alias ElixirBandits.Auth.Guardian
  
    action_fallback ElixirBanditsWeb.FallbackController
  
    def create(conn, %{"user" => user_params}) do
        case authenticate(user_params) do
            {:ok, username} ->
              new_conn = Guardian.Plug.sign_in(conn, username)
              jwt = Guardian.Plug.current_token(new_conn)
      
              new_conn
              |> put_status(:created)
              |> render("show.json", user: username, jwt: jwt)
              |> put_resp_header("location", Routes.user_path(conn, :create, user_params))
      
            :error ->
              conn
              |> put_status(:unauthorized)
              |> render("error.json", error: "User or email invalid")
        end
    end
  
    def delete(conn, _) do
        conn
        |> Guardian.Plug.sign_out()
        |> put_status(:no_content)
        |> render("delete.json")
    end

    def refresh(conn, _params) do
        user = Guardian.Plug.current_resource(conn)
        jwt = Guardian.Plug.current_token(conn)
    
        case Guardian.refresh(jwt, ttl: {30, :days}) do
          {:ok, _, {new_jwt, _new_claims}} ->
            conn
            |> put_status(:ok)
            |> render("show.json", user: user, jwt: new_jwt)
    
          {:error, _reason} ->
            conn
            |> put_status(:unauthorized)
            |> render("error.json", error: "Not Authenticated")
        end
    end

    defp authenticate(%{"username" => username, "password" => password}) do
        Accounts.authenticate(username, password)
    end

    defp authenticate(_) do
        :error
    end
  end