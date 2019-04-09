defmodule Phoneapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Phoneapp.EtsCache

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Phoneapp.Repo,
      # Start the endpoint when the application starts
      PhoneappWeb.Endpoint
      # Starts a worker by calling: Phoneapp.Worker.start_link(arg)
      # {Phoneapp.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phoneapp.Supervisor]
    Supervisor.start_link(children, opts) |> post_start()
  end

  # Start the app with cache initialized.
  defp post_start(callback) do
    EtsCache.start()
    callback
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhoneappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
