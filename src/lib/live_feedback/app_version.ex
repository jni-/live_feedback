defmodule LiveFeedback.AppVersion do
  def version_id do
    case System.cmd("cat", ["/proc/self/cgroup"]) do
      {cgroup_info, 0} ->
        version_id cgroup_info
      _ ->
        "Unable to read version"
    end
  end

  def version_id(cgroup_info) do
    case Regex.run(~r/[0-9a-f]{64}/, cgroup_info) do
      [<< first_match :: size(12)-binary, _ :: binary >>| _rest] ->
        first_match
      nil ->
        "Unable to read version"
    end
  end
end
