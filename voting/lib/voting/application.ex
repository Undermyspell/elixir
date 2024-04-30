defmodule Voting.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  require Logger

  use Application

  @impl true
  def start(_type, _args) do
    %{host: host, password: password, port: port} =
      case Application.get_env(:testcontainers, :enabled, false) do
        true ->
          Testcontainers.start_link()
          config = Testcontainers.Container.new("redis/redis-stack:latest")
          config = Testcontainers.Container.with_exposed_port(config, 6379)

          case Testcontainers.start_container(config) do
            {:ok, container} ->
              port = Testcontainers.Container.mapped_port(container, 6379)
              host = Testcontainers.get_host()
              Logger.info("Redis testcontainer started on #{host}:#{port}")
              %{host: host, password: nil, port: port}

            {:error, reason} ->
              Logger.error("Failed to start redis test container: #{reason}")
          end

        false ->
          Application.get_env(:voting, :redis)
      end

    children = [
      VotingWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:voting, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Voting.PubSub},
      {Voting.Shared.Auth.KeycloakStrategy, time_interval: 60_000, log_level: :warn},
      {Voting.Repositories.Redis,
       name: Voting.Repositories.Redis, host: host, port: port, password: password},
      # Start a worker by calling: Voting.Worker.start_link(arg)
      # {Voting.Worker, arg},
      # Start to serve requests, typically the last entry
      VotingWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Voting.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VotingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
