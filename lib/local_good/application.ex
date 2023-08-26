defmodule LocalGood.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LocalGoodWeb.Telemetry,
      # Start the Ecto repository
      LocalGood.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LocalGood.PubSub},
      # Start Finch
      {Finch, name: LocalGood.Finch},
      # Start the Endpoint (http/https)
      LocalGoodWeb.Endpoint
      # Start a worker by calling: LocalGood.Worker.start_link(arg)
      # {LocalGood.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LocalGood.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LocalGoodWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
