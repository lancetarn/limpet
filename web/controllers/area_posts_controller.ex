defmodule Limpet.AreaPostsController do
  use Limpet.Web, :controller
  import Ecto.Query
  import Geo.PostGIS

  alias Limpet.Post

  def index(conn, params) do
    area = polygon_from_params(params)
    query = from p in Post,
      where: st_contains(^area, p.location)
    area_posts = Repo.all(query)
    render(conn, "index.json", area_posts: area_posts)
  end

  def create(conn, %{"area_posts" => area_posts_params}) do
    changeset = Post.changeset(%Post{}, area_posts_params)

    case Repo.insert(changeset) do
      {:ok, area_posts} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", area_posts_path(conn, :show, area_posts))
        |> render("show.json", area_posts: area_posts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Limpet.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    area_posts = Repo.get!(Post, id)
    render(conn, "show.json", area_posts: area_posts)
  end

  def update(conn, %{"id" => id, "area_posts" => area_posts_params}) do
    area_posts = Repo.get!(Post, id)
    changeset = Post.changeset(area_posts, area_posts_params)

    case Repo.update(changeset) do
      {:ok, area_posts} ->
        render(conn, "show.json", area_posts: area_posts)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Limpet.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    area_posts = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(area_posts)

    send_resp(conn, :no_content, "")
  end

  def polygon_from_params(%{"geojson" => geojson}) do
    Poison.Parser.parse!(geojson)
    |> Geo.JSON.decode()
  end

end
