defmodule LiveFeedback.AdminController do
  use Phoenix.Controller

  plug :authenticate, :admin when action in [:dashboard]
  plug :action

  def index(conn, _params) do
    render conn, "index"
  end

  def login(conn, params) do
    config = Application.get_env(:live_feedback, :admin, [])
    if config[:password] == params["admin_password"] do
      conn = put_session conn, :is_admin, true
      redirect conn, "/admin/dashboard"
    else
      conn = put_session conn, :is_admin, false
      redirect conn, "/admin"
    end
  end

  def dashboard(conn, params) do
    render conn, "dashboard"
  end

  defp authenticate(conn, :admin) do
    if !get_session(conn, :is_admin) do
      conn = redirect conn, "/admin"
      conn = halt conn
    end
    conn
  end

end
