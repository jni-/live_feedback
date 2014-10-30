defmodule Conference do
  use DDBModel, key: :name

  defcolumn :name, type: :string
  defcolumn :enabled, type: :number
  defcolumn :slug, type: :string

end
