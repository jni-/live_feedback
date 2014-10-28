defmodule LiveFeedback.PageController do
  use Phoenix.Controller

  plug :authenticate
  plug :action

  alias Poison, as: JSON

  def index(conn, _params) do
    render conn, "index"
  end

  def comment(conn, _params) do
    case Comment.new(comment: "beu").insert! do
      {:ok, comment} ->
        render conn, "comment"
      err ->
        IO.inspect err
        render conn, "index"
    end
  end

  def register_emotion(conn, params) do
    user_id = get_session(conn, :user_id)
    case Emotion.new(hash: user_id <> params["emotion"], emotion: params["emotion"], value: params["value"]).put! do
      {:ok, emotion} ->
        json conn, JSON.encode!(:ok)
      {:error, err} ->
        json conn, JSON.encode!(%{error: Tuple.to_list(err)})
    end
  end

  defp authenticate(conn, _options) do
    if get_session(conn, :user_id) == nil do
      conn = put_session(conn, :user_id, to_string(:uuid.to_string(:uuid.uuid4())))
    end
    conn
  end

end
