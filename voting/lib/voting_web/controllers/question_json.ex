defmodule VotingWeb.QuestionJSON do
  alias Voting.Models.Question

  @doc """
  Renders a list of questions.
  """
  @spec questions(%{:questions => list()}) :: list()
  def questions(%{questions: questions}) do
    for(question <- questions, do: data(question))
  end

  @doc """
  Renders a single question.
  """
  def show(%{question: question}) do
    %{data: data(question)}
  end

  def token(%{Token: token, Token2: token2}) do
    %{
      Token: token,
      Token2: token2
    }
  end

  defp data(%Question{} = question) do
    %{
      id: question.id,
      text: question.text,
      votes: question.votes,
      answered: question.answered,
      voted: question.voted,
      creatorHash: question.creatorHash,
      creatorName: question.creatorName,
      anonymous: question.anonymous
    }
  end
end
