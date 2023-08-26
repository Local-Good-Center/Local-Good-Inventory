defmodule LocalGood.Repo do
  use Ecto.Repo,
    otp_app: :local_good,
    adapter: Ecto.Adapters.Postgres
end
