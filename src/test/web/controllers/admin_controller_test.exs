defmodule LiveFeedback.AdminControllerTest do
  use ExUnit.Case, async: false
  use ConnHelper

  alias Poison, as: JSON
  import Mock

  @admin_root_url "/admin"
  @admin_password "right password"

  setup do
    Plug.Session.init(store: Plug.ProcessStore, key: "foobar")
    :ok
  end

  test "Index renders the view" do
    %{resp_body: body} = call(LiveFeedback.Router, :get, "#{@admin_root_url}/")
    assert body =~ "Admin password"
  end

  test "Login with wrong password redirects to index" do
    %{resp_headers: headers} = call(LiveFeedback.Router, :post, "#{@admin_root_url}/login", [admin_password: "wrong"])

    {_, location} = Enum.find headers, fn({key, _}) -> key == "Location" end

    assert "/admin" == location
  end

  test "Login with wrong password removes flag in session" do
    conn = call(LiveFeedback.Router, :post, "#{@admin_root_url}/login", [admin_password: "wrong"])

    refute Plug.Conn.get_session(conn, :is_admin)
  end

  test "Login with right password redirects to dashboard" do
    %{resp_headers: headers} = call(LiveFeedback.Router, :post, "#{@admin_root_url}/login", [admin_password: @admin_password])

    {_, location} = Enum.find headers, fn({key, _}) -> key == "Location" end

    assert "/admin/dashboard" == location
  end

  test "Login with right password adds flag in session" do
    conn = call(LiveFeedback.Router, :post, "#{@admin_root_url}/login", [admin_password: @admin_password])

    assert Plug.Conn.get_session(conn, :is_admin)
  end

  test "Accessing the dashboard without being logged in redirects to the login page" do
    %{resp_headers: headers} = call(LiveFeedback.Router, :get, "#{@admin_root_url}/dashboard", [])

    assert Enum.find headers, fn({key, _}) -> key == "Location" end
  end

  test "Accessing the dashboard when logged in displays the dashboard" do
    %{resp_body: body} = LiveFeedback.AdminController.dashboard(after_logging_in_as_admin(), nil)

    assert body =~ "Live Feedback Dashboard"
  end

  defp after_logging_in_as_admin() do
    conn = call(LiveFeedback.Router, :post, "#{@admin_root_url}/login", [admin_password: @admin_password])
    %{conn | state: :unset}
  end


end
