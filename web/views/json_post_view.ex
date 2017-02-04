defmodule Limpet.JsonPostView do
  use Limpet.Web, :view

  def render("index.json", %{json_posts: json_posts}) do
    %{data: render_many(json_posts, Limpet.JsonPostView, "json_post.json")}
  end

  def render("show.json", %{json_post: json_post}) do
    %{data: render_one(json_post, Limpet.JsonPostView, "json_post.json")}
  end

  def render("json_post.json", %{json_post: json_post}) do
    %{id: json_post.id}
  end
end
