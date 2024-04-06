defmodule Test1Web.Graphql.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  forward "/graphiql",
    to: Absinthe.Plug.GraphiQL,
    init_opts: [interface: :playground, schema: Test1Web.Graphql.Schema]
end
