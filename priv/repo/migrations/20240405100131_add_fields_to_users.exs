defmodule Test1.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_name, :string
    end
  end
end
