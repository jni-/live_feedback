defmodule LiveFeedback.Router do
  use Phoenix.Router

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/", LiveFeedback.PageController, :index, as: :pages
    get "/comment", LiveFeedback.PageController, :comment, as: :pages
    post "/register-emotion", LiveFeedback.PageController, :register_emotion, as: :pages
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
