defmodule Limpet.PostMapController do
  use Limpet.Web, :controller

  alias Limpet.Post

  def index(conn, _params) do
    posts = Repo.all(Post)
    case Poison.encode(posts) do
      {:ok, posts} ->
        render(conn, "index.html", json_posts: posts)
      {:error, _, _} ->
        render(conn, "index.html", json_posts: "[]")
    end
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post_map" => post_map_params}) do
    changeset = Post.changeset(%Post{}, post_map_params)

    case Repo.insert(changeset) do
      {:ok, _post_map} ->
        conn
        |> put_flash(:info, "Post map created successfully.")
        |> redirect(to: post_map_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post_map = Repo.get!(Post, id)
    render(conn, "show.html", post_map: post_map)
  end

  def edit(conn, %{"id" => id}) do
    post_map = Repo.get!(Post, id)
    changeset = Post.changeset(post_map)
    render(conn, "edit.html", post_map: post_map, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post_map" => post_map_params}) do
    post_map = Repo.get!(Post, id)
    changeset = Post.changeset(post_map, post_map_params)

    case Repo.update(changeset) do
      {:ok, post_map} ->
        conn
        |> put_flash(:info, "Post map updated successfully.")
        |> redirect(to: post_map_path(conn, :show, post_map))
      {:error, changeset} ->
        render(conn, "edit.html", post_map: post_map, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post_map = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post_map)

    conn
    |> put_flash(:info, "Post map deleted successfully.")
    |> redirect(to: post_map_path(conn, :index))
  end
end
