defmodule Limpet.FormPost do
  use Limpet.Web, :model

  embedded_schema do
    field :lat, :float
    field :lng, :float
    field :message, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:lat, :lng, :message])
    |> validate_required([:lat, :lng, :message])
  end

  def to_post(changeset) do
    form_post = apply_changes(changeset)
    %Limpet.Post{location: %Geo.Point{coordinates: {form_post.lng, form_post.lat}, srid: 4326}, message: form_post.message}
  end
end
