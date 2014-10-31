defmodule LiveFeedback.AdminController do
  use Phoenix.Controller

  plug :authenticate, :admin when action in [:dashboard]
  plug :action

  alias Poison, as: JSON

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

  def dashboard(conn, _params) do
    {:ok, _, conferences} = Conference.scan

    render conn, "dashboard",
      conferences: conferences
  end

  def rankings(conn, _params) do
    {:ok, _, emotions} = Emotion.scan

    rankings = Enum.filter(emotions, fn({Emotion, emotion}) -> emotion[:value] =~ ~r/[0-9]{1,2}/ end)
                |> Enum.group_by(fn({Emotion, emotion}) -> {emotion[:emotion], emotion[:conference_name]} end)
                |> Enum.map(fn({key, values}) -> {key, List.foldr(values, 0, fn({Emotion, dict}, acc) -> acc + String.to_integer(dict[:value]) end) / Enum.count(values)} end)
                |> Enum.map(fn({{emotion, conference}, average}) -> %{emotion: emotion, conference: conference, average: average} end)

    json conn, JSON.encode!(rankings)
  end


  defp authenticate(conn, :admin) do
    if !get_session(conn, :is_admin) do
      conn = redirect conn, "/admin"
      conn = halt conn
    end
    conn
  end

end
