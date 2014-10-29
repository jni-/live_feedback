LiveFeedback.Router.start
ExUnit.start

defmodule ConnHelper do
  import Plug.Test

  defmacro __using__(_) do
    quote do
      import ConnHelper
      use Plug.Test
    end
  end

  def call(router, verb, path, params \\ nil, headers \\ []) do
    router.call(conn(verb, path, params, headers), router.init([]))
  end

end

# Taken from the plug project
defmodule Plug.ProcessStore do
  @behaviour Plug.Session.Store

  def init(_opts) do
    nil
  end

  def get(_conn, sid, nil) do
    {sid, Process.get({:session, sid}) || %{}}
  end

  def delete(_conn, sid, nil) do
    Process.delete({:session, sid})
    :ok
  end

  def put(conn, nil, data, nil) do
    sid = :crypto.strong_rand_bytes(96) |> Base.encode64
    put(conn, sid, data, nil)
  end

  def put(_conn, sid, data, nil) do
    Process.put({:session, sid}, data)
    sid
  end
end
