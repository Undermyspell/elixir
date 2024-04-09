defmodule Voting.Redis do
  use Agent
  require Logger

  @redis_host ""
  @redis_port 11436
  @redis_password ""

  def start_link(opts \\ []) do
    Agent.start_link(fn -> connect() end, opts)
  end

  defp connect() do
    {:ok, conn} =
      Redix.start_link(host: @redis_host, port: @redis_port, password: @redis_password)

    Logger.info("Connected to Redis")
    conn
  end
end
