defmodule LiveFeedback.LayoutView do
  use LiveFeedback.View

  def version_id do
    IO.puts "Reading file"
    version = case System.cmd("cat", ["/proc/self/cgroup"]) do
      {cgroup_info, 0} ->
        version_id cgroup_info
      _ ->
        "Unable to read version"
    end
    IO.puts "Done reading file"
    version
  end

  def version_id(cgroup_info) do
    IO.puts "Starting to read string"
    version = cgroup_info
      |> String.split("\n")
      |> Enum.filter(fn(x) -> String.contains?(x, "docker-") end)
      |> Enum.at(0)
      |> String.split("docker-")
      |> Enum.at(1)
      |> String.split(".scope")
      |> Enum.at(0)
    IO.puts "Done reading string"
    version
  end

end
