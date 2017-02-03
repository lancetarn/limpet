defmodule Limpet.PostController do
  use Limpet.Web, :controller

  alias Limpet.Post
  alias Limpet.FormPost

  def index(conn, _params) do
    posts = Repo.all(Post)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = FormPost.changeset(%FormPost{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"form_post" => post_params}) do
    changeset = FormPost.changeset(%FormPost{}, post_params)
    if !changeset.valid? do
        changeset = %{changeset | action: :create}
        render(conn, "new.html", changeset: changeset)
    else
      post = FormPost.to_post(changeset)
      post_change = Post.changeset(%Post{}, Map.from_struct(post))

      case Repo.insert(post_change) do
        {:ok, _post} ->
          conn
          |> put_flash(:info, "Post created successfully.")
          |> redirect(to: post_path(conn, :index))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end

  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    form_post = Post.to_form_post(post)
    changeset = FormPost.changeset(form_post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "form_post" => post_params}) do
    post = Repo.get!(Post, id)
    form_changeset = FormPost.changeset(%FormPost{}, post_params)
    if !form_changeset.valid? do
        changeset = %{form_changeset | action: :create}
        render(conn, "edit.html", changeset: changeset, post: post)
    else
      post_changeset = Post.changeset(post, Map.from_struct(FormPost.to_post(form_changeset)))

      case Repo.update(post_changeset) do
        {:ok, post} ->
          conn
          |> put_flash(:info, "Post updated successfully.")
          |> redirect(to: post_path(conn, :show, post))
        {:error, changeset} ->
          render(conn, "edit.html", post: post, changeset: changeset)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end
end
