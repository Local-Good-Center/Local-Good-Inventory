defmodule LocalGood.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :text
      add :image_url, :text
      add :event_info, :text
      add :registration_link, :text
      add :times, {:array, :utc_datetime}, default: [], null: false
      add :date, :date
      add :slug, :text, null: false
      add :display, :boolean, default: true, null: false
      add :reservation_required, :boolean, default: true, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:slug, :date], unique: true, where: "date IS NOT NULL")
  end
end
