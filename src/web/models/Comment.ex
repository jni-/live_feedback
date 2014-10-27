defmodule Comment do
  use DDBModel

  defcolumn :hash, type: :uuid
  defcolumn :comment, default: "", type: :string
end
