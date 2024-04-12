defmodule Voting.Question do
  @derive Jason.Encoder
  defstruct id: nil, votes: nil, creator: nil, text: nil

  @type t :: %__MODULE__{
          id: integer(),
          votes: integer(),
          creator: String.t(),
          text: String.t()
        }

  defguard is_even(term) when is_integer(term) and rem(term, 2) == 0

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

  defp ensure_no_property_is_nil(%Voting.Question{} = q)
       when not is_nil(q.creator) and not is_nil(q.text) and not is_nil(q.text) and
              not is_nil(q.votes) do
    true
  end

  defp ensure_no_property_is_nil(_) do
    false
  end
end

defprotocol QuestionProtocol do
  def vote(question)
end

defimpl QuestionProtocol, for: Voting.Question do
  @spec vote(Voting.Question.t()) :: Voting.Question.t()
  def vote(%Voting.Question{} = question) do
    question = %Voting.Question{question | votes: question.votes + 1}

    q = %Voting.Question{id: 1, creator: 123, text: "asd", votes: "aasd"}

    IO.puts(q)

    IO.puts(
      "Your Question is now #{question.text}, voted: #{question.votes}, from: #{question.creator}"
    )

    question
  end
end
