defmodule LiveFeedback.PageController do
  use Phoenix.Controller

  plug :authenticate
  plug :action

  alias Poison, as: JSON

  def index(conn, _params) do
    {:ok, _, conferences} = Conference.scan

    render conn, "index",
      conferences: conferences |> Enum.filter(fn({Conference, conference}) -> conference[:enabled] == 1 end)
  end

  def register_emotion(conn, params) do
    user_id = get_session(conn, :user_id)
    case Emotion.new(hash: user_id <> params["emotion"] <> params["conference"], emotion: params["emotion"], value: params["value"], conference_name: params["conference"]).put! do
      {:ok, emotion} ->
        Phoenix.Channel.broadcast "generic", "global", "emotions-changed", %{}
        json conn, JSON.encode!(:ok)
      {:error, err} ->
        json conn, JSON.encode!(%{error: Tuple.to_list(err)})
    end
  end

  def signal_reload(conn, params) do
    config = Application.get_env(:live_feedback, :reloads, [:key])
    if config[:key] == params["key"] do
      Phoenix.Channel.broadcast "generic", "global", "reload", %{current_version: LiveFeedback.AppVersion.version_id}
    end

    json conn, JSON.encode!(:ok)
  end

  def version(conn, _params) do
    json conn, JSON.encode!(%{version: LiveFeedback.AppVersion.version_id})
  end

  defp authenticate(conn, _options) do
    if get_session(conn, :user_id) == nil do
      conn = put_session(conn, :user_id, to_string(:uuid.to_string(:uuid.uuid4())))
    end
    conn
  end

end

