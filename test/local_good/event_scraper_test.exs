defmodule LocalGood.EventScraperTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  alias LocalGood.EventScraper

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  test "should get events from the website" do
    use_cassette "local_good/event_scraper_test" do
      events = EventScraper.get_events()

      assert length(events) == 10
      assert Enum.any?(events, &(&1.title == "Friday Fitness Class"))
    end
  end
end
