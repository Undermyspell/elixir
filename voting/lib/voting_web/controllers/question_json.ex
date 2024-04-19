defmodule VotingWeb.QuestionJSON do
  alias Voting.VotingSession.Question

  @doc """
  Renders a list of questions.
  """
  def index(%{questions: questions}) do
    %{data: for(question <- questions, do: data(question))}
  end

  @spec show(%{:question => Voting.VotingSession.Question.t(), optional(any()) => any()}) :: %{
          data: %{
            anonymous: any(),
            answered: any(),
            creatorHash: any(),
            creatorName: any(),
            id: any(),
            text: any(),
            voted: any(),
            votes: any()
          }
        }
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
