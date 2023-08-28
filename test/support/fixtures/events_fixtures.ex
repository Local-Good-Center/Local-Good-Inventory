defmodule LocalGood.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LocalGood.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        display: true,
        event_info: "some event_info",
        image_url: "some image_url",
        registration_link: "some registration_link",
        reservation_required: true,
        times: [],
        title: "some title"
      })
      |> LocalGood.Events.create_event()

    event
  end
end
