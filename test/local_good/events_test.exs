defmodule LocalGood.EventsTest do
  use LocalGood.DataCase

  alias LocalGood.Events

  describe "events" do
    alias LocalGood.Events.Event

    import LocalGood.EventsFixtures

    @invalid_attrs %{display: nil, event_info: nil, image_url: nil, registration_link: nil, reservation_required: nil, times: nil, title: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{display: true, event_info: "some event_info", image_url: "some image_url", registration_link: "some registration_link", reservation_required: true, times: [], title: "some title"}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.display == true
      assert event.event_info == "some event_info"
      assert event.image_url == "some image_url"
      assert event.registration_link == "some registration_link"
      assert event.reservation_required == true
      assert event.times == []
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{display: false, event_info: "some updated event_info", image_url: "some updated image_url", registration_link: "some updated registration_link", reservation_required: false, times: [], title: "some updated title"}

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.display == false
      assert event.event_info == "some updated event_info"
      assert event.image_url == "some updated image_url"
      assert event.registration_link == "some updated registration_link"
      assert event.reservation_required == false
      assert event.times == []
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
