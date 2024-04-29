defmodule Voting.UseCases.GetSession do

  alias Voting.Models.Question
  alias Voting.Repositories.Redis

  @spec get_session() :: {:ok, [Question.t()]} | {:error}
  def get_session() do
    Redis.get_connection() |> Redis.getQuestions()
  end
end
