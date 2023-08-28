defmodule LocalGoodWeb.EventJSON do
  alias LocalGood.Events.Event

  @doc """
  Renders a list of events.
  """
  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  @doc """
  Renders a single event.
  """
  def show(%{event: event}) do
    %{data: data(event)}
  end

  defp data(%Event{} = event) do
    %{
      id: event.id,
      title: event.title,
      image_url: event.image_url,
      event_info: event.event_info,
      registration_link: event.registration_link,
      times: event.times,
      display: event.display,
      reservation_required: event.reservation_required,
      slug: event.slug
    }
  end
end
