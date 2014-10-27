defmodule LiveFeedback.LayoutViewTest do
  use ExUnit.Case

  alias LiveFeedback.LayoutView

  @cgroup_info_1_15 """
    8:bfqio:/
    7:blkio:/system.slice/docker-7a21ae39ee1e0c32d53da3361892257aeafff1ceeaeb9fea91dfae14acbae58b.scope
  """

  @cgroup_info_1_14 """
    10:perf_event:/docker/7a21ae39ee1e0c32d53da3361892257aeafff1ceeaeb9fea91dfae14acbae58b
    9:memory:/docker/7a21ae39ee1e0c32d53da3361892257aeafff1ceeaeb9fea91dfae14acbae58b
    8:hugetlb:/
  """

  @version_from_cgroup "7a21ae39ee1e0c32d53da3361892257aeafff1ceeaeb9fea91dfae14acbae58b"

  test "can extract version from cgroup info version 1.15" do
    assert LayoutView.version_id(@cgroup_info_1_15) == @version_from_cgroup
  end

  test "can extract version from cgroup info version 1.14" do
    assert LayoutView.version_id(@cgroup_info_1_14) == @version_from_cgroup
  end

  test "returns an error message if unable to read version string" do
    assert LayoutView.version_id("not a docker version") == "Unable to read version"
  end

end
