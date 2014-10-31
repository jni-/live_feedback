defmodule Emotion do
  use DDBModel

  defcolumn :hash, type: :string
  defcolumn :emotion, type: :string
  defcolumn :value, type: :string
  defcolumn :conference_name, type: :string

end
