defmodule Limpet.PostMapControllerTest do
  use Limpet.ConnCase

  alias Limpet.PostMap
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_map_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing post maps"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, post_map_path(conn, :new)
    assert html_response(conn, 200) =~ "New post map"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, post_map_path(conn, :create), post_map: @valid_attrs
    assert redirected_to(conn) == post_map_path(conn, :index)
    assert Repo.get_by(PostMap, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_map_path(conn, :create), post_map: @invalid_attrs
    assert html_response(conn, 200) =~ "New post map"
  end

  test "shows chosen resource", %{conn: conn} do
    post_map = Repo.insert! %PostMap{}
    conn = get conn, post_map_path(conn, :show, post_map)
    assert html_response(conn, 200) =~ "Show post map"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_map_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    post_map = Repo.insert! %PostMap{}
    conn = get conn, post_map_path(conn, :edit, post_map)
    assert html_response(conn, 200) =~ "Edit post map"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    post_map = Repo.insert! %PostMap{}
    conn = put conn, post_map_path(conn, :update, post_map), post_map: @valid_attrs
    assert redirected_to(conn) == post_map_path(conn, :show, post_map)
    assert Repo.get_by(PostMap, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post_map = Repo.insert! %PostMap{}
    conn = put conn, post_map_path(conn, :update, post_map), post_map: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit post map"
  end

  test "deletes chosen resource", %{conn: conn} do
    post_map = Repo.insert! %PostMap{}
    conn = delete conn, post_map_path(conn, :delete, post_map)
    assert redirected_to(conn) == post_map_path(conn, :index)
    refute Repo.get(PostMap, post_map.id)
  end
end
