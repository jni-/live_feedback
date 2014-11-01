defmodule LiveFeedback.PageControllerTest do
  use ExUnit.Case, async: false
  use ConnHelper

  alias Poison, as: JSON
  import Mock

  @emotion_parameters %{value: 1, emotion: "nothing", conference: "elixir"}
  @deploy_key "12345"

  setup do
    Plug.Session.init(store: Plug.ProcessStore, key: "foobar")
    :ok
  end

  test "Index renders the view" do
    with_mock Conference, [scan: fn() -> {:ok, 1, []} end] do
      %{resp_body: body} = call(LiveFeedback.Router, :get, "/")
      assert body =~ "Vous êtes sur la version"
    end
  end

  test "Register emotion persists the emotion" do
    with_mock :erlcloud_ddb2, [put_item: fn(_, _) -> {:ok, nil} end] do
      conn = call(LiveFeedback.Router, :post, "/register-emotion", @emotion_parameters)
      assert called :erlcloud_ddb2.put_item("Emotion", emotion_for_current_user(conn))
    end
  end

  test "Register emotion outputs JSON ok if no error" do
    with_mock :erlcloud_ddb2, [put_item: fn(_, item) -> {:ok, item} end] do
      %{resp_body: body} = call(LiveFeedback.Router, :post, "/register-emotion", @emotion_parameters)
      assert body == JSON.encode!(:ok)
    end
  end

  test "Register emotion outputs JSON with error in case of persistence error" do
    with_mock :erlcloud_ddb2, [put_item: fn(_, _) -> {:error, {"not working"}} end] do
      %{resp_body: body} = call(LiveFeedback.Router, :post, "/register-emotion", @emotion_parameters)
      assert body =~ "error"
      assert body =~ "not working"
    end
  end

  test "Signal reload works with the proper key" do
    Phoenix.Topic.subscribe self, "generic:global"
    call(LiveFeedback.Router, :get, "/signal-reload", [key: @deploy_key])

    answer = receive do
      %{event: "reload"} -> :ok
      _ -> :error
    after
      10 -> :timeout
    end

    assert :ok == answer

  end

  test "Signal reload does not work with the wrong key" do
    Phoenix.Topic.subscribe self, "generic:global"
    call(LiveFeedback.Router, :get, "/signal-reload", [key: String.reverse @deploy_key])

    answer = receive do
      %{event: "reload"} -> :ok
      _ -> :error
    after
      10 -> :timeout
    end

    assert :error == answer

  end

  test "Signal reload sends the current version in the message" do
    Phoenix.Topic.subscribe self, "generic:global"
    call(LiveFeedback.Router, :get, "/signal-reload", [key: @deploy_key])

    answer = receive do
      %{message: %{current_version: version}} -> version
    after
      10 -> :timeout
    end

    assert answer == LiveFeedback.AppVersion.version_id

  end

  test "Version returns the current version" do
    %{resp_body: body} = call(LiveFeedback.Router, :get, "/version")
    assert body =~ LiveFeedback.AppVersion.version_id
  end

  defp emotion_for_current_user(conn) do
      user_id = Plug.Conn.get_session(conn, :user_id)
      Emotion.new(hash: user_id <> @emotion_parameters[:emotion] <> @emotion_parameters[:conference], emotion: @emotion_parameters[:emotion], value: @emotion_parameters[:value], conference_name: @emotion_parameters[:conference]).to_dynamo
  end

  defp enabled_conference do
    {Conference, Enum.into([{:name, "Enabled-conference"}, {:enabled, 1}], HashDict.new)}
  end

  defp disabled_conference do
    {Conference, Enum.into([{:name, "Disabled-conference"}, {:enabled, 0}], HashDict.new)}
  end

end
