defmodule Limpet.Post do
  use Limpet.Web, :model
  require Logger

  @web_mercator_srid 3857

  @derive {Poison.Encoder, only: [:message, :location]}
  schema "posts" do
    field :location, Geo.Point
    field :message, :string
    field :is_encrypted, :boolean, [default: false]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    Logger.debug "Post: #{inspect(params)}"
    struct
    |> convert_latlng(params)
    |> cast(params, [:location, :message])
    |> validate_required([:location, :message])
    |> enforce_valid_point
  end

  def to_form_post(post) do
    %Limpet.FormPost{lat: Limpet.PostView.get_post_lat(post), lng: Limpet.PostView.get_post_lng(post), message: post.message}
  end

  def encode_post(post) do
    %{post | location: Geo.JSON.encode(post.location)}
  end

  defp convert_latlng(post, params) do
    case post do
      %{lat: lat, lng: lng, location: nil} ->
        %{post | location: %Geo.Point{coordinates: {lng, lat}, srid: @web_mercator_srid}}
      _ ->
        post
    end
  end

  defp enforce_valid_point(changeset) do
    Logger.debug "Changeset: #{inspect(changeset)}"
    {:ok, location} = fetch_change(changeset, :location)
    if is_float(elem(location.coordinates, 0)) && is_float(elem(location.coordinates, 1)) do
      changeset
    else
      %{changeset | errors: changeset.errors ++ [{:location, {"Location contains invalid coordinates"}, []}], valid?: :false}
    end
  end

  defimpl Poison.Encoder, for: Limpet.Post do
    def encode(post, options) do
      post = Limpet.Post.encode_post(post)
      Poison.Encoder.Map.encode(Map.take(post, [:message, :location]), options)
    end
  end

end
