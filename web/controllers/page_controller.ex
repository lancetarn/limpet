defmodule Limpet.PageController do
  use Limpet.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
