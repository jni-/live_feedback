defmodule LiveFeedback.Generic do
  use Phoenix.Channel

  def join(socket, "global", _message) do
    {:ok, socket}
  end

  def join(socket, _no, _message) do
    {:error, socket, :unauthorized}
  end

end
