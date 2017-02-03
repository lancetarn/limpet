defmodule Limpet.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def up do
    create table(:posts) do
      add :message, :string

      timestamps()
    end

    execute("SELECT AddGeometryColumn ('posts','location',4326,'POINT',2)")
  end

  def down do
    drop table(:posts)
  end
end
