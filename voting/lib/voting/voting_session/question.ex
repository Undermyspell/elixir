defmodule Voting.VotingSession.Question do
  alias Voting.VotingSession.Question

  @derive Jason.Encoder
  defstruct id: nil,
            text: nil,
            votes: nil,
            answered: nil,
            voted: nil,
            creatorHash: nil,
            creatorName: nil,
            anonymous: nil

  @type t :: %__MODULE__{
          id: integer(),
          text: String.t(),
          votes: integer(),
          answered: boolean(),
          voted: boolean(),
          creatorHash: String.t(),
          creatorName: String.t(),
          anonymous: boolean()
        }

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  @spec create(nonempty_maybe_improper_list()) :: {:error, String.t()} | {:ok, struct()}
  def create(question) when is_list(question) and hd(question) |> is_map() do
    qM = hd(question)

    newQ =
      qM
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
      |> Map.new()

    with q <- struct(Voting.Question, newQ),
         true <- ensure_no_property_is_nil(q) do
      {:ok, q}
    else
      false ->
        {:error, "Not a valid question"}
    end
  end

  defp ensure_no_property_is_nil(%Question{} = q)
       when not is_nil(q.creator) and not is_nil(q.text) and not is_nil(q.text) and
              not is_nil(q.votes) do
    true
  end

  defp ensure_no_property_is_nil(_) do
    false
  end
end
