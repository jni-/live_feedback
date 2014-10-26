defmodule LiveFeedback.LayoutView do
  use LiveFeedback.View

  def version_id do
    case System.cmd("cat", ["/proc/self/cgroup"]) do
      {cgroup_info, 0} ->
        version_id cgroup_info
      _ ->
        "Unable to read version"
    end
  end

  def version_id(cgroup_info) do
    cgroup_info
      |> String.split("\n")
      |> Enum.filter(fn(x) -> String.contains?(x, "docker-") end)
      |> Enum.at(0)
      |> String.split("docker-")
      |> Enum.at(1)
      |> String.split(".scope")
      |> Enum.at(0)
  end

end
