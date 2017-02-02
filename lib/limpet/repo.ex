defmodule Limpet.Repo do
  use Ecto.Repo, otp_app: :limpet

  # Geo extensions
  Postgrex.Types.define(Limpet.PostgresTypes,
                [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
                json: Poison)
end
