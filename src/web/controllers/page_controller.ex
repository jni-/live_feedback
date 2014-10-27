defmodule LiveFeedback.PageController do
  use Phoenix.Controller

  plug :action

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

end
