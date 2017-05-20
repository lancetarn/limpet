defmodule Limpet.AreaPostsControllerTest do
  use Limpet.ConnCase

  alias Limpet.AreaPosts
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, area_posts_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    area_posts = Repo.insert! %AreaPosts{}
    conn = get conn, area_posts_path(conn, :show, area_posts)
    assert json_response(conn, 200)["data"] == %{"id" => area_posts.id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, area_posts_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, area_posts_path(conn, :create), area_posts: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(AreaPosts, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, area_posts_path(conn, :create), area_posts: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    area_posts = Repo.insert! %AreaPosts{}
    conn = put conn, area_posts_path(conn, :update, area_posts), area_posts: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(AreaPosts, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    area_posts = Repo.insert! %AreaPosts{}
    conn = put conn, area_posts_path(conn, :update, area_posts), area_posts: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    area_posts = Repo.insert! %AreaPosts{}
    conn = delete conn, area_posts_path(conn, :delete, area_posts)
    assert response(conn, 204)
    refute Repo.get(AreaPosts, area_posts.id)
  end
end
