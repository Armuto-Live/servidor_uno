defmodule Test1Web.Router do
  use Test1Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Test1Web do
    pipe_through :api
  end

  # scope "/api" do
  #  pipe_through :api

  #  forward "/graphql", Absinthe.Plug.GraphiQL, schema: Test1Web.Graphql.Schema
  # end

  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug.GraphiQL,
      schema: Test1Web.Graphql.Schema,
      socket: Test1Web.UserSocket,
      socket_url: "ws://localhost:4000/api/graphql",
      interface: :advanced
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:test1, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
