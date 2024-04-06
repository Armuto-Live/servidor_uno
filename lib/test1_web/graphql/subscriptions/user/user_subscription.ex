defmodule Test1Web.Graphql.Subscriptions.User.UserSubscription do
  use Absinthe.Schema.Notation

  object :user_subscriptions do
    field :new_users, non_null(:user) do
      config(fn _args, _resolution ->
        {:ok, topic: "user_created"}
      end)

      trigger(:create_user, topic: fn _ -> "user_created" end)
    end
  end
end
