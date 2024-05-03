defmodule Voting.Models.Question do
  alias Voting.Models.Question

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
  Creates a question struct from raw json

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  @spec create(nonempty_maybe_improper_list()) :: {:error, String.t()} | {:ok, Question.t()}
  def create(question) when is_list(question) and hd(question) |> is_map() do
    qM = hd(question) |> Map.put("voted", false)

    newQ =
      qM
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
      |> Map.new()

    with q <- struct(Question, newQ),
         true <- ensure_no_property_is_nil(q) do
      {:ok, q}
    else
      false ->
        {:error, "Not a valid question"}
    end
  end

  @spec create(%Voting.Repositories.RedisQuestion{}) :: Question.t()
  def create(%Voting.Repositories.RedisQuestion{} = rq) do
    %Question{
      id: rq.id,
      text: rq.text,
      anonymous: rq.anonymous,
      answered: rq.answered,
      creatorHash: rq.creatorHash,
      creatorName: rq.creatorName,
      voted: false,
      votes: rq.votes
    }
  end

  defp ensure_no_property_is_nil(%Question{} = q) do
    q |> Map.keys() |> Enum.all?(&(Map.get(q, &1) != nil))
  end
end
