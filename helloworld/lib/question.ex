defmodule Voting.Question do
  defstruct votes: 0, creator: "", text: ""

  @type t :: %__MODULE__{
          votes: integer(),
          creator: String.t(),
          text: String.t()
        }

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  @spec testy(Voting.Question.t()) :: Voting.Question.t()
  def testy(_) do
    q = %Voting.Question{creator: "123", text: "asd", votes: 0}
    q
  end
end

defprotocol QuestionProtocol do
  def vote(question)
end

defimpl QuestionProtocol, for: Voting.Question do
  @spec vote(Voting.Question.t()) :: Voting.Question.t()
  def vote(%Voting.Question{} = question) do
    question = %Voting.Question{question | votes: question.votes + 1}

    q = %Voting.Question{creator: 123, text: "asd", votes: "aasd"}

    IO.puts(q)

    IO.puts(
      "Your Question is now #{question.text}, voted: #{question.votes}, from: #{question.creator}"
    )

    question
  end
end
