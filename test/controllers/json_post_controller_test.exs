defmodule Limpet.JsonPostControllerTest do
  use Limpet.ConnCase

  alias Limpet.JsonPost
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
  #
  #  test "lists all entries on index", %{conn: conn} do
  #    conn = get conn, json_post_path(conn, :index)
  #    assert json_response(conn, 200)["data"] == []
  #  end
  #
  #  test "shows chosen resource", %{conn: conn} do
  #    json_post = Repo.insert! %JsonPost{}
  #    conn = get conn, json_post_path(conn, :show, json_post)
  #    assert json_response(conn, 200)["data"] == %{"id" => json_post.id}
  #  end
  #
  #  test "renders page not found when id is nonexistent", %{conn: conn} do
  #    assert_error_sent 404, fn ->
  #      get conn, json_post_path(conn, :show, -1)
  #    end
  #  end
  #
  #  test "creates and renders resource when data is valid", %{conn: conn} do
  #    conn = post conn, json_post_path(conn, :create), json_post: @valid_attrs
  #    assert json_response(conn, 201)["data"]["id"]
  #    assert Repo.get_by(JsonPost, @valid_attrs)
  #  end
  #
  #  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #    conn = post conn, json_post_path(conn, :create), json_post: @invalid_attrs
  #    assert json_response(conn, 422)["errors"] != %{}
  #  end
  #
  #  test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #    json_post = Repo.insert! %JsonPost{}
  #    conn = put conn, json_post_path(conn, :update, json_post), json_post: @valid_attrs
  #    assert json_response(conn, 200)["data"]["id"]
  #    assert Repo.get_by(JsonPost, @valid_attrs)
  #  end
  #
  #  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #    json_post = Repo.insert! %JsonPost{}
  #    conn = put conn, json_post_path(conn, :update, json_post), json_post: @invalid_attrs
  #    assert json_response(conn, 422)["errors"] != %{}
  #  end
  #
  #  test "deletes chosen resource", %{conn: conn} do
  #    json_post = Repo.insert! %JsonPost{}
  #    conn = delete conn, json_post_path(conn, :delete, json_post)
  #    assert response(conn, 204)
  #    refute Repo.get(JsonPost, json_post.id)
  #  end
  end
