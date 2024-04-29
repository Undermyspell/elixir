defmodule Voting.Repositories.Redis do
  use Agent
  require Logger

  alias Voting.Models.Question
  alias Voting.Repositories.RedisQuestion

  @spec start_link() :: {:error, any()} | {:ok, pid()}
  def start_link(opts \\ []) do
    Logger.info(opts)
    Agent.start_link(fn -> connect() end, opts)
  end

  @spec get_connection() :: pid()
  def get_connection() do
    Agent.get(Voting.Repositories.Redis, fn conn -> conn end)
  end

  def start_session(conn) do
    sessionSecret = Voting.Shared.Helper.Utility.get_random_string()
    session = %{Questions: %{}, UserVotes: %{}, SessionSecret: sessionSecret}

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
  @spec addQuestion(
          pid(),
          String.t(),
          boolean(),
          String.t(),
          String.t()
        ) :: {:error, String.t()} | {:ok, Voting.Models.Question.t()}
  def addQuestion(conn, text, anonymous, creatorName, creatorHash) do
    newQ = RedisQuestion.new(text, creatorName, creatorHash, anonymous)

    {:ok, val} = Jason.encode(newQ)

    with {:ok, res} <-
           Redix.command(conn, ["JSON.SET", "Voting", "$.Questions.#{newQ.id}", val]) do
      IO.puts(res)
      q = Question.create(newQ)
      {:ok, q}
    else
      {:error, err} ->
        IO.puts("Error in with")
        IO.inspect(err)
    end
  end

  @spec getQuestions(pid()) ::
          {:ok, [Question.t()]} | {:error}
  def getQuestions(conn) do
    try do
      {:ok, res} = Redix.command(conn, ["JSON.GET", "Voting", ".Questions"])
      {:ok, dec} = Jason.decode(res)

      questions =
        dec
        |> Map.to_list()
        |> Enum.map(fn {_, inner_map} ->
          inner_map
        end)
        |> Enum.map(&RedisQuestion.new(&1))
        |> Enum.map(&Question.create(&1))

      Logger.info(questions)
      {:ok, questions}
    rescue
      e ->
        Logger.error(e)
        {:error}
    end
  end

  defp connect() do
    %{host: host, password: password, port: port} = Application.get_env(:voting, :redis)

    {:ok, conn} = Redix.start_link(host: host, port: port, password: password)

    Logger.info("Connected to Redis")
    conn
  end
end
