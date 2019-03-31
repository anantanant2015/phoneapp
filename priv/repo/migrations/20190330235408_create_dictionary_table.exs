defmodule Phoneapp.Repo.Migrations.CreateDictionaryTable do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create table(:dictionary) do
      add :object, :map
    end
  end
end
