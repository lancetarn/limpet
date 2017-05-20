defmodule Limpet.AreaPostsView do
  use Limpet.Web, :view

  def render("index.json", %{area_posts: area_posts}) do
    %{data: render_many(area_posts, Limpet.AreaPostsView, "area_posts.json")}
  end

  def render("show.json", %{area_posts: area_posts}) do
    %{data: render_one(area_posts, Limpet.AreaPostsView, "area_posts.json")}
  end

  def render("area_posts.json", %{area_posts: area_posts}) do
    %{id: area_posts.id}
  end
end
