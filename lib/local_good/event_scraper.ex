defmodule LocalGood.EventScraper do
  @moduledoc """
  Scrapes events from the LocalGoodCenter website.
  """
  @events_page "https://www.localgoodcenter.org/events"
  @empty_floki_element Floki.parse_fragment!("")

  @type scraped_event :: %{
          title: String.t(),
          image_url: String.t(),
          event_info: String.t(),
          registration_link: String.t(),
          times: [DateTime.t()],
          display: boolean(),
          reservation_required: boolean()
        }

  @doc """
  Parses the events page and returns a list of events.
  """
  @spec get_events() :: [scraped_event()]
  def get_events do
    {:ok, document} =
      @events_page
      |> Req.get!()
      |> Map.get(:body)
      |> Floki.parse_document()

    title_elements = Floki.find(document, "a.eventlist-title-link")
    imageElements = Floki.find(document, "img.eventlist-thumbnail")
    event_info_elements = Floki.find(document, "div.sqs-block-html")
    registration_links = Floki.find(document, "a.sqs-block-button-element")
    time_elements = Floki.find(document, "li.eventlist-meta-item")

    title_elements
    |> Enum.with_index()
    |> Enum.map(fn {title_element, index} ->
      imageElement = Enum.at(imageElements, index, @empty_floki_element)
      event_info_element = Enum.at(event_info_elements, index, @empty_floki_element)
      registration_link = Enum.at(registration_links, index, @empty_floki_element)

      times =
        time_elements
        |> Enum.at(index, @empty_floki_element)
        |> parse_datetimes_from_element()

      %{
        title: Floki.text(title_element),
        image_url: Floki.attribute(imageElement, "src") |> List.first(),
        event_info: Floki.text(event_info_element),
        registration_link: Floki.attribute(registration_link, "href") |> List.first(),
        times: times,
        date: get_date(times),
        display: true,
        reservation_required: true
      }
    end)
  end

  # HELPERS

  def get_date(times) do
    case List.first(times) do
      nil -> nil
      datetime -> Timex.to_date(datetime)
    end
  end

  defp parse_datetimes_from_element(time_element) do
    times = Floki.find(time_element, "time")

    times
    |> Enum.map(&Floki.text/1)
    |> Enum.zip(Floki.attribute(times, "datetime"))
    |> Enum.map(fn {text, datetime} ->
      # only contains ':' for hours

      if String.contains?(text, ":") do
        datetime_str = "#{datetime} #{text} America/Chicago"

        datetime_str
        |> Timex.parse!("%Y-%m-%d %l:%M %p %Z", :strftime)
        |> Timex.to_datetime(:utc)
      else
        datetime
        |> Timex.parse!("%Y-%m-%d", :strftime)
        |> Timex.to_datetime(:utc)
      end
    end)
  end
end
