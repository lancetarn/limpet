defmodule Limpet.PostTest do
  use Limpet.ModelCase

  alias Limpet.Post
  require Logger

  test "changeset with valid attributes" do
    valid = %{location: %{"coordinates" => [45.1, -12.1], "crs" => %{"properties" => %{"name" => 3857}, "type" => "name"}, "type" => "Point"}, message: "some content", is_encrypted: true}
    changeset = Post.changeset(%Post{}, valid)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    invalid = %{location: %{"coordinates" => [nil, nil], "crs" => %{"properties" => %{"name" => 3857}, "type" => "name"}, "type" => "Point"}, is_encrypted: true}
    changeset = Post.changeset(%Post{}, invalid)
    refute changeset.valid?
  end
end
