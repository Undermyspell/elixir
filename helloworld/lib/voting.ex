defmodule Voting do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: Voting.TaskSupervisor},
      {Voting.Broker, name: Voting.Broker},
      {Voting.Redis, name: Voting.Redis}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Voting.Supervisor)
  end

  def subscribe(useremail) do
    current = Application.get_env(:voting, :config)

    IO.inspect(current)

    q = %Voting.Question{id: 12, creator: "its me", text: "Who am i?", votes: 3}

    conn = Voting.Redis.get_connection()

    IO.inspect(conn)
    Voting.Redis.addQuestion(conn, q)

    {:ok, _} = Voting.Broker.subscribe(Voting.Broker, useremail, fn -> serve(useremail) end)
  end

  def notifyall() do
    Voting.Broker.notifyall(Voting.Broker)
  end

  def killrandom() do
    Voting.Broker.killrandom(Voting.Broker)
  end

  defp serve(useremail) do
    receive do
      {:message, msg} ->
        Logger.info("Received message for #{useremail}: #{msg}")
        serve(useremail)
    end
  end

  def main do
    # IO.puts(:helloworld)
    # asd = [1, 2, 3]
    # xxx = [ 0 | asd]
    # IO.inspect(xxx)

    name = IO.gets("What is your name?\n") |> String.trim()
    IO.puts("Your name is #{name}")

    if name === "bob" do
      IO.puts("You enterd the correct name bob")
    end

    case name do
      "bob" -> IO.puts("matches bob")
      name when name === "alice" -> IO.puts("iit matches alice")
      _ -> IO.puts("did not match")
    end

    # cond do
    #   String.starts_with?(name, "a") -> IO.puts("starts with an a")
    #   String.starts_with?(name, "b") -> IO.puts("starts with an b")
    # end

    question = %Voting.Question{votes: 1, creator: "Michael", text: "Whats your name?"}

    QuestionProtocol.vote(question)

    IO.inspect(question)
    :world
  end
end
