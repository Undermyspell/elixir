defmodule Voting do
  use Application

  def start(_type, _args) do
    # Helloworld.main()

    children = [
      {Task.Supervisor, name: Voting.TaskSupervisor},
      {Voting.Broker, name: Voting.Broker}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Voting.Supervisor)
  end

  def subscribe(useremail) do
    {:ok, pid} = Task.Supervisor.start_child(Voting.TaskSupervisor, fn -> serve(useremail) end)

    # random_number = :rand.uniform(100)
    Voting.Broker.subscribe(Voting.Broker, pid, useremail)
  end

  def notifyall() do
    Voting.Broker.notifyall(Voting.Broker)
  end

  def killrandom() do
    Voting.Broker.killrandom()
  end

  defp serve(useremail) do
    # receive do
    #   {:disconnected, pid, msg} ->
    #     IO.puts("Usermail: #{useremail} - Received message: #{msg} - Process: " <> inspect(pid))
    #     serve(useremail)
    # end
    receive do
      x ->
        IO.inspect(x)
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
