defmodule Voting.Broker do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def subscribe(server, pid, useremail) do
    GenServer.call(server, {:subscribe, pid, useremail})
  end

  def notifyall(server) do
    GenServer.cast(server, {:notifyall})
  end

  def killrandom() do
    GenServer.call(__MODULE__, {:killrandom})
  end

  @impl true
  def init(:ok) do
    userConns = %{}
    refs = %{}
    {:ok, {userConns, refs}}
  end

  @impl true
  def handle_call({:subscribe, pid, useremail}, _from, {userConns, refs}) do
    ref = Process.monitor(pid)
    refs = Map.put(refs, ref, useremail)

    if not Map.has_key?(userConns, useremail) do
      userConns = Map.put(userConns, useremail, [pid])
      {:reply, :ok, {userConns, refs}}
    else
      userConns = Map.put(userConns, useremail, [pid | Map.get(userConns, useremail)])
      {:reply, :ok, {userConns, refs}}
    end
  end

  @impl true
  def handle_call({:killrandom}, _from, state) do
    {userConns, _} = state
    randomUserConn = userConns |> Map.keys() |> Enum.random()
    randomPid = Map.get(userConns, randomUserConn) |> Enum.random()

    IO.puts("Killed process #{randomUserConn} - " <> inspect(randomPid))
    Process.exit(randomPid, :notnormal)

    {:reply, :ok, state}
  end

  @impl true
  def handle_cast({:notifyall}, state) do
    IO.inspect(state)

    {userConns, _} = state

    userConns
    |> Enum.each(fn {key, value} ->
      Enum.each(value, fn value ->
        send(value, {:message, "Hello #{key}"})
      end)
    end)

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, pid, _reason}, {userConns, refs}) do
    Logger.info("DOWN")
    IO.puts("Down message for - " <> inspect(pid))
    {userEmail, refs} = Map.pop(refs, ref)
    pids = Map.get(userConns, userEmail)
    patchedPids = List.delete(pids, pid)

    userConns =
      case length(patchedPids) do
        0 -> Map.delete(userConns, userEmail)
        _ -> Map.put(userConns, userEmail, patchedPids)
      end

    IO.inspect(userConns)

    send(pid, {:disconnected, "User process disconnected"})

    {:noreply, {userConns, refs}}
  end
end
