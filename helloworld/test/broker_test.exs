defmodule VotingTest do
  use ExUnit.Case, async: true

  setup do
    broker = start_supervised!(Voting.Broker)
    %{broker: broker}
  end

  defp loop() do
    loop()
  end

  test "subscribe a new user connection", %{broker: broker} do
    res = Voting.Broker.subscribe(broker, "test@test.com", fn -> loop() end)
    assert {:ok, _} = res
    {:ok, pid} = res
    assert pid != nil

    state = :sys.get_state(broker)

    {userConns, _} = state

    assert Map.get(userConns, "test@test.com") == [pid]
  end
end
