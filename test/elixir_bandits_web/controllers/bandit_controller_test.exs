defmodule ElixirBanditsWeb.BanditControllerTest do
  use ElixirBanditsWeb.ConnCase

  alias ElixirBandits.Bandits
  alias ElixirBandits.Bandits.Bandit

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:bandit) do
    {:ok, bandit} = Bandits.create_bandit(@create_attrs)
    bandit
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all bandit", %{conn: conn} do
      conn = get(conn, Routes.bandit_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bandit" do
    test "renders bandit when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bandit_path(conn, :create), bandit: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.bandit_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bandit_path(conn, :create), bandit: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bandit" do
    setup [:create_bandit]

    test "renders bandit when data is valid", %{conn: conn, bandit: %Bandit{id: id} = bandit} do
      conn = put(conn, Routes.bandit_path(conn, :update, bandit), bandit: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.bandit_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bandit: bandit} do
      conn = put(conn, Routes.bandit_path(conn, :update, bandit), bandit: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bandit" do
    setup [:create_bandit]

    test "deletes chosen bandit", %{conn: conn, bandit: bandit} do
      conn = delete(conn, Routes.bandit_path(conn, :delete, bandit))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.bandit_path(conn, :show, bandit))
      end
    end
  end

  defp create_bandit(_) do
    bandit = fixture(:bandit)
    {:ok, bandit: bandit}
  end
end
