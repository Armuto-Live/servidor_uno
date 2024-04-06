defmodule Test1.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Test1.Repo

  schema "users" do
    field :name, :string
    field :last_name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :last_name])
    |> validate_required([:name, :last_name])
  end

  def create_user(new_user) do
    %Test1.User{}
    |> changeset(new_user)
    |> dbg()
    |> Repo.insert()
  end

  def delete_user(id) do
    Repo.get(Test1.User, id)
    |> case do
      nil -> {:error, "User not found"}
      user -> Repo.delete(user) |> dbg
    end
  end

  def show_users() do
    Repo.all(Test1.User)
  end

  def show_user(id) do
    Repo.get(Test1.User, id)
  end

  def update_user(id, new_data) do
    user = Test1.Repo.get(Test1.User, id)
    changeset = changeset(user, new_data)
    Test1.Repo.update(changeset)
  end
end
