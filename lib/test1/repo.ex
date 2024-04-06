defmodule Test1.Repo do
  use Ecto.Repo,
    otp_app: :test1,
    adapter: Ecto.Adapters.Postgres
end
