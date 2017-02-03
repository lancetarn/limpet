defmodule Limpet.PostView do
  use Limpet.Web, :view

  def get_post_lat(post) do
    elem(post.location.coordinates, 1)
  end

  def get_post_lng(post) do
    elem(post.location.coordinates, 0)
  end
end
