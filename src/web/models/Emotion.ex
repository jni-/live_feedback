defmodule Emotion do
  use DDBModel

  defcolumn :hash, type: :string
  defcolumn :emotion
  defcolumn :value

end
