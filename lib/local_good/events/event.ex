defmodule LocalGood.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(
    display
    reservation_required
    title
    )a

  @fields ~w(
    date
    event_info
    image_url
    registration_link
    times
  )a ++ @required

  schema "events" do
    field :date, :date
    field :display, :boolean, default: true
    field :event_info, :string
    field :image_url, :string
    field :registration_link, :string
    field :reservation_required, :boolean, default: true
    field :slug, :string
    field :times, {:array, :utc_datetime}
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @fields)
    |> validate_required(@required)
    |> create_slug()
    |> unique_constraint([:slug, :date])
  end

  # HELPERS

  defp create_slug(%Ecto.Changeset{valid?: false} = changeset), do: changeset

  defp create_slug(changeset) do
    case get_change(changeset, :title) do
      nil -> changeset
      title -> put_change(changeset, :slug, slugify_title(title))
    end
  end

  defp slugify_title(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9]/, "_")
    |> String.replace(~r/^-|-$/, "")
  end
end
