defmodule LiveFeedback.LayoutViewTest do
  use ExUnit.Case

  alias LiveFeedback.LayoutView

  @cgroup_info """
    8:bfqio:/
    7:blkio:/system.slice/docker-7a21ae39ee1e0c32d53da3361892257aeafff1ceeaeb9fea91dfae14acbae58b.scope
  """

  @version_from_cgroup "7a21ae39ee1e0c32d53da3361892257aeafff1ceeaeb9fea91dfae14acbae58b"

  test "can extract version from cgroup info" do
    assert LayoutView.version_id(@cgroup_info) == @version_from_cgroup
  end
end
