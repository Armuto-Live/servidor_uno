defmodule Test1.Group do
  use Ecto.Schema
  import Ecto.Changeset

  alias Test1.Repo

  schema "groups" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def create_group(new_group) do
    %Test1.Group{}
    |> changeset(new_group)
    |> dbg()
    |> Repo.insert()
  end

  def show_groups() do
    Repo.all(Test1.Group)
  end

  def show_group(id) do
    Repo.get(Test1.Group, id)
  end
end
