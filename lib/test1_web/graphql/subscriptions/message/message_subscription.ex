defmodule Test1Web.Graphql.Subscriptions.Message.MessageSubscription do
  use Absinthe.Schema.Notation

  object :user_subscriptions do
    field :new_message, non_null(:user) do
      config(fn _args, _resolution ->
        {:ok, topic: "message_send"}
      end)

      trigger(:create_user, topic: fn _ -> "message_send" end)
    end
  end
end
