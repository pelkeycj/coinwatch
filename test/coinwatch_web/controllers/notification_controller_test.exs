defmodule CoinwatchWeb.NotificationControllerTest do
  use CoinwatchWeb.ConnCase

  alias Coinwatch.Assets

  @create_attrs %{high: true, notified: true, threshold: 42}
  @update_attrs %{high: false, notified: false, threshold: 43}
  @invalid_attrs %{high: nil, notified: nil, threshold: nil}

  def fixture(:notification) do
    {:ok, notification} = Assets.create_notification(@create_attrs)
    notification
  end

  describe "index" do
    test "lists all notifications", %{conn: conn} do
      conn = get conn, notification_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Notifications"
    end
  end

  describe "new notification" do
    test "renders form", %{conn: conn} do
      conn = get conn, notification_path(conn, :new)
      assert html_response(conn, 200) =~ "New Notification"
    end
  end

  describe "create notification" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, notification_path(conn, :create), notification: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == notification_path(conn, :show, id)

      conn = get conn, notification_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Notification"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, notification_path(conn, :create), notification: @invalid_attrs
      assert html_response(conn, 200) =~ "New Notification"
    end
  end

  describe "edit notification" do
    setup [:create_notification]

    test "renders form for editing chosen notification", %{conn: conn, notification: notification} do
      conn = get conn, notification_path(conn, :edit, notification)
      assert html_response(conn, 200) =~ "Edit Notification"
    end
  end

  describe "update notification" do
    setup [:create_notification]

    test "redirects when data is valid", %{conn: conn, notification: notification} do
      conn = put conn, notification_path(conn, :update, notification), notification: @update_attrs
      assert redirected_to(conn) == notification_path(conn, :show, notification)

      conn = get conn, notification_path(conn, :show, notification)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, notification: notification} do
      conn = put conn, notification_path(conn, :update, notification), notification: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Notification"
    end
  end

  describe "delete notification" do
    setup [:create_notification]

    test "deletes chosen notification", %{conn: conn, notification: notification} do
      conn = delete conn, notification_path(conn, :delete, notification)
      assert redirected_to(conn) == notification_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, notification_path(conn, :show, notification)
      end
    end
  end

  defp create_notification(_) do
    notification = fixture(:notification)
    {:ok, notification: notification}
  end
end
