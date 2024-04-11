defmodule Voting.Redis do
  use Agent
  require Logger

  @redis_host ""
  @redis_port 11436
  @redis_password ""

  @spec start_link() :: {:error, any()} | {:ok, pid()}
  def start_link(opts \\ []) do
    Agent.start_link(fn -> connect() end, opts)
  end

  @spec get_connection() :: pid()
  def get_connection() do
    Agent.get(Voting.Redis, fn conn -> conn end)
  end

  @doc """
  Adds a new question to the current voting session
  """
  @spec addQuestion(pid(), Voting.Question.t()) :: nil
  def addQuestion(conn, %Voting.Question{} = question) do
    {:ok, val} = Jason.encode(question)

    with {:ok, res} <-
           Redix.command(conn, ["JSON.SET", "Voting", "$", val]) do
      IO.puts(res)
    else
      {:error, err} ->
        IO.puts("Error in with")
        IO.inspect(err)
    end

    {:ok, res} = Redix.command(conn, ["JSON.GET", "Voting"])
    {:ok, dec} = Jason.decode(res)

    q = Voting.Question.create(dec)
    IO.inspect(q)

    nil
  end

  def getQuestions(conn) do
    {:ok, val} = Redix.command(conn, ["JSON.GET", "Voting", ".Questions"])
    IO.inspect(val)
    nil
  end

  defp connect() do
    {:ok, conn} =
      Redix.start_link(host: @redis_host, port: @redis_port, password: @redis_password)

    Logger.info("Connected to Redis")
    IO.inspect(conn)
    conn
  end
end
