defmodule Phoneapp.Repo do
  use Ecto.Repo,
    otp_app: :phoneapp,
    adapter: Ecto.Adapters.Postgres
end
