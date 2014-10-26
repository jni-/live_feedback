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
    IO.inspect cgroup_info
    IO.puts "------- 1"

    version_lines = cgroup_info |> String.split("\n")
    IO.inspect version_lines
    IO.puts "------- 2"

    docker_version_lines = version_lines |> Enum.filter(fn(x) -> String.contains?(x, "docker-") end)
    IO.inspect docker_version_lines
    IO.puts "------- 3"

    first_docker_version = docker_version_lines |> Enum.at(0)
    IO.inspect first_docker_version
    IO.puts "------- 4"

    extract_after_docker = first_docker_version |> String.split("docker-")
    IO.inspect extract_after_docker
    IO.puts "------- 5"

    second_part = extract_after_docker |> Enum.at(1)
    IO.inspect second_part
    IO.puts "------- 6"

    extract_before_scope = second_part |> String.split(".scope")
    IO.inspect extract_before_scope
    IO.puts "------- 7"

    IO.puts "Done reading string"
    extract_before_scope |> Enum.at(0)
  end

end
