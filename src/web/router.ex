defmodule LiveFeedback.Router do
  use Phoenix.Router
  use Phoenix.Router.Socket, mount: "/ws"

  channel "generic", LiveFeedback.Generic

  scope "/" do
    pipe_through :browser

    get "/", LiveFeedback.PageController, :index, as: :pages
    get "/signal-reload", LiveFeedback.PageController, :signal_reload, as: :pages
    get "/version", LiveFeedback.PageController, :version, as: :pages
    post "/register-emotion", LiveFeedback.PageController, :register_emotion, as: :pages
  end

  scope "/admin" do
    pipe_through :browser

    get "/", LiveFeedback.AdminController, :index, as: :pages
    post "/login", LiveFeedback.AdminController, :login, as: :pages
    get "/dashboard", LiveFeedback.AdminController, :dashboard, as: :pages
    get "/rankings", LiveFeedback.AdminController, :rankings, as: :pages
  end

end
