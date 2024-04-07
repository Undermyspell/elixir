defmodule Voting.Question do
  defstruct votes: 0, creator: "", text: ""
end

defprotocol QuestionProtocol do
  def vote(question)
end

defimpl QuestionProtocol, for: Voting.Question do
  @spec vote(Voting.Question.t()) :: Voting.Question.t()
  def vote(%Voting.Question{} = question) do
    question = %Voting.Question{question | votes: question.votes + 1}

    IO.puts(
      "Your Question is now #{question.text}, voted: #{question.votes}, from: #{question.creator}"
    )

    question
  end
end
