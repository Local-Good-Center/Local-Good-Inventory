defmodule LocalGoodWeb.EventControllerTest do
  use LocalGoodWeb.ConnCase

  import LocalGood.EventsFixtures

  alias LocalGood.Events.Event

  @create_attrs %{
    display: true,
    event_info: "some event_info",
    image_url: "some image_url",
    registration_link: "some registration_link",
    reservation_required: true,
    times: [],
    title: "some title"
  }
  @update_attrs %{
    display: false,
    event_info: "some updated event_info",
    image_url: "some updated image_url",
    registration_link: "some updated registration_link",
    reservation_required: false,
    times: [],
    title: "some updated title"
  }
  @invalid_attrs %{display: nil, event_info: nil, image_url: nil, registration_link: nil, reservation_required: nil, times: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, ~p"/api/events")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "display" => true,
               "event_info" => "some event_info",
               "image_url" => "some image_url",
               "registration_link" => "some registration_link",
               "reservation_required" => true,
               "times" => [],
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/events", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/events/#{id}")

      assert %{
               "id" => ^id,
               "display" => false,
               "event_info" => "some updated event_info",
               "image_url" => "some updated image_url",
               "registration_link" => "some updated registration_link",
               "reservation_required" => false,
               "times" => [],
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, ~p"/api/events/#{event}", event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, ~p"/api/events/#{event}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/events/#{event}")
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
