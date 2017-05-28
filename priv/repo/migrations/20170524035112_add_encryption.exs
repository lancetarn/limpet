defmodule Limpet.Repo.Migrations.AddEncryption do
  use Ecto.Migration

  def up do
    alter table(:posts) do
      add :is_encrypted, :boolean, [default: false, null: false]
    end
  end

  def down do
    alter table(:posts) do
      remove :is_encrypted
    end
  end
end
