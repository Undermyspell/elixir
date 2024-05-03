defmodule Voting.Shared.Helper.Utility do
  @spec get_random_string() :: String.t()
  def get_random_string do
    charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ12456789'

    1..30
    |> Enum.map(fn _ -> Enum.random(charset) end)
    |> List.to_string()
  end
end
