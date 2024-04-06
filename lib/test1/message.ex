defmodule Test1.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Test1.Repo

  schema "messages" do
    field :content, :string
    field :user_id, :id
    field :group_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :user_id, :group_id])
    |> validate_required([:content])
  end

  def create_message(new_group) do
    %Test1.Message{}
    |> changeset(new_group)
    |> dbg()
    |> Repo.insert()
  end

  def show_message() do
    Repo.all(Test1.Message)
  end

  def update_message(id, new_data) do
    user = Repo.get(Test1.Message, id)
    changeset = changeset(user, new_data)
    Repo.update(changeset)
  end
end
