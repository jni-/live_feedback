defmodule LiveFeedback.LayoutView do
  use LiveFeedback.View

  def version_id do
    LiveFeedback.AppVersion.version_id
  end

end
