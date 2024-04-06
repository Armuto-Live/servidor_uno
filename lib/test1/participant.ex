defmodule Test1.Participant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Test1.Repo

  schema "participants" do
    field :user_id, :id
    field :group_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:user_id, :group_id])
    |> validate_required([])
  end

  def create_participant(new_participant) do
    %Test1.Participant{}
    |> changeset(new_participant)
    |> dbg()
    |> Repo.insert()
  end

  def show_participant(id) do
    Repo.get(Test1.Participant, id)
  end

  def show_participants() do
    Repo.all(Test1.Participant)
  end
end
