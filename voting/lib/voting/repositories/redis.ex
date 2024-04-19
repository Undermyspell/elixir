defmodule Voting.Repositories.Redis do
  use Agent
  require Logger

  alias Voting.VotingSession.Question

  @spec start_link() :: {:error, any()} | {:ok, pid()}
  def start_link(opts \\ []) do
    Agent.start_link(fn -> connect() end, opts)
  end

  @spec get_connection() :: pid()
  def get_connection() do
    Agent.get(Voting.Repositories.Redis, fn conn -> conn end)
  end

  def start_session(conn) do
    session = %{Questions: %{}}

    try do
      with {:ok, val} <- Jason.encode(session),
           {:ok, _} <-
             Redix.command(conn, ["JSON.DEL", "Voting"]),
           {:ok, _} <-
             Redix.command(conn, ["JSON.SET", "Voting", "$", val]) do
        {:ok}
      else
        {:error, err} ->
          Logger.error(err)
          {:error}
      end
    rescue
      e in Redix.Error ->
        Logger.error(e.message)
        {:error}
    end
  end

  @doc """
  Adds a new question to the current voting session
  """
  @spec addQuestion(pid(), Question.t()) :: nil
  def addQuestion(conn, %Voting.VotingSession.Question{} = question) do
    {:ok, val} = Jason.encode(question)

    with {:ok, res} <-
           Redix.command(conn, ["JSON.SET", "Voting", "$.Questions.#{question.id}", val]) do
      IO.puts(res)
    else
      {:error, err} ->
        IO.puts("Error in with")
        IO.inspect(err)
    end

    {:ok, res} = Redix.command(conn, ["JSON.GET", "Voting", "$.Questions.#{question.id}"])
    {:ok, dec} = Jason.decode(res)

    try do
      q = Question.create(dec)
      IO.inspect(q)
    rescue
      e in FunctionClauseError -> IO.inspect(e)
    end

    nil
  end

  def getQuestions(conn) do
    {:ok, val} = Redix.command(conn, ["JSON.GET", "Voting", ".Questions"])
    IO.inspect(val)
    nil
  end

  defp connect() do
    %{host: host, password: password, port: port} = Application.get_env(:voting, :redis)

    {:ok, conn} = Redix.start_link(host: host, port: port, password: password)

    Logger.info("Connected to Redis")
    IO.inspect(conn)
    conn
  end
end
