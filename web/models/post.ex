defmodule Limpet.Post do
  use Limpet.Web, :model

  @derive {Poison.Encoder, only: [:message, :location]}
  schema "posts" do
    field :location, Geo.Point
    field :message, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:location, :message])
    |> validate_required([:location, :message])
  end

  def to_form_post(post) do
    %Limpet.FormPost{lat: Limpet.PostView.get_post_lat(post), lng: Limpet.PostView.get_post_lng(post), message: post.message}
  end

end
