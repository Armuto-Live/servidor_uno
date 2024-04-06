defmodule Test1Web.Graphql.Schema do
  use Absinthe.Schema
  import_types(Absinthe.Type.Custom)
  import Test1Web.Graphql.Subscriptions.User.UserSubscription

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :last_name, :string
    field :inserted_at, non_null(:naive_datetime)
    field :updated_at, non_null(:naive_datetime)
  end

  object :group do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :inserted_at, non_null(:naive_datetime)
    field :updated_at, non_null(:naive_datetime)
  end

  object :participant do
    field :id, non_null(:id)
    field :user_id, non_null(:id)
    field :group_id, non_null(:id)
    field :inserted_at, non_null(:naive_datetime)
    field :updated_at, non_null(:naive_datetime)
  end

  object :message do
    field :id, non_null(:id)
    field :content, non_null(:string)
    field :user_id, non_null(:id)
    field :group_id, :id
    field :inserted_at, non_null(:naive_datetime)
    field :updated_at, non_null(:naive_datetime)
  end

  # Resolvers
  def get_user(%{id: id}, _) do
    case Test1.User.show_user(id) do
      nil ->
        {:error, "User not found"}

      user ->
        {:ok, user}
    end
  end

  query do
    field :get_user, non_null(:user) do
      arg(:id, non_null(:id))

      resolve(&get_user/2)
    end

    field :get_users, list_of(:user) do
      resolve(fn _, _ -> {:ok, Test1.User.show_users()} end)
    end

    field :get_group, non_null(:group) do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _ -> {:ok, Test1.Group.show_group(id)} end)
    end

    field :get_groups, list_of(:group) do
      resolve(fn _, _ -> {:ok, Test1.Group.show_groups()} end)
    end

    field :get_participant, non_null(:participant) do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _ -> {:ok, Test1.Participant.show_participant(id)} end)
    end

    field :get_participants, list_of(:participant) do
      resolve(fn _, _ -> {:ok, Test1.Participant.show_participants()} end)
    end

    field :get_message, list_of(:message) do
      resolve(fn _, _ -> {:ok, Test1.Message.show_message()} end)
    end
  end

  input_object :create_user_input do
    field :name, non_null(:string)
    field :last_name, non_null(:string)
  end

  input_object :create_group_input do
    field :name, non_null(:string)
  end

  input_object :create_participan_input do
    field :name, non_null(:string)
  end

  input_object :create_message_input do
    field :content, non_null(:string)
    field :user_id, non_null(:id)
    field :group_id, :id
  end

  mutation do
    field :create_user, type: non_null(:user) do
      arg(:input, non_null(:create_user_input))

      resolve(fn %{input: args}, _ -> Test1.User.create_user(args) end)
    end

    field :delete_user, type: non_null(:user) do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _ ->
        Test1.User.delete_user(id)
      end)
    end

    field :create_group, type: non_null(:group) do
      arg(:input, non_null(:create_group_input))

      resolve(fn %{input: args}, _ -> Test1.Group.create_group(args) end)
    end

    field :create_message, type: non_null(:message) do
      arg(:input, non_null(:create_message_input))

      resolve(fn %{input: args}, _ -> Test1.Message.create_message(args) end)
    end
  end

  subscription do
    field :new_users, :user do
      arg(:admin, non_null(:boolean))

      config(fn args, _info ->
        if args.admin do
          {:ok, topic: "admin"}
        else
          {:ok, topic: "no-admin"}
        end
      end)

      trigger(:create_user,
        topic: fn _user ->
          ["admin"]
        end
      )
    end

    field :new_message, :message do
      arg(:group_ids, list_of(:id))

      config(fn args, _info ->
        topics =
          args.group_ids
          |> Enum.map(fn id ->
            "grupo:#{id}"
          end)
          |> Enum.concat(["grupo:*"])

        {:ok, topic: topics}
      end)

      trigger([:create_message, :update_message],
        topic: fn message ->
          dbg(message)

          case message.group_id do
            nil -> ["grupo:*"]
            id -> ["grupo:#{id}"]
          end
        end
      )
    end
  end
end
