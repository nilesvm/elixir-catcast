defmodule CatcastsWeb.Router do
  use CatcastsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Catcasts.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug CatcastsWeb.Plugs.RequireAuth
  end

  scope "/", CatcastsWeb do
    pipe_through [:browser, :auth]

    resources "/videos", VideoController, only: [:new, :create]
  end

  scope "/", CatcastsWeb do
    pipe_through :browser

    resources "/videos", VideoController, only: [:index, :show, :delete]
    get "/", PageController, :index
  end

  # for Google Auth
  scope "/auth", CatcastsWeb do
    pipe_through :browser

    get "/signout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :new
  end

end
