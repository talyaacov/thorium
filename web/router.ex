defmodule Thorium.Router do
  use Thorium.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :csrf do
    plug :protect_from_forgery
  end
  
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    if Mix.env == :dev do
      get "/graphiql", Absinthe.Plug.GraphiQL, schema: Thorium.Schema
      post "/graphiql", Absinthe.Plug.GraphiQL, schema: Thorium.Schema
    end
  end

  scope "/", Thorium do
    pipe_through :browser
    post "/assets", PageController, :assets_upload
    get "/assets", PageController, :assets_get
    get "/reset", PageController, :reset_db
    get "/*path", PageController, :index
  end

  scope "/graphql" do
    pipe_through :api

    forward "/", Absinthe.Plug, schema: Thorium.Schema
  end
end