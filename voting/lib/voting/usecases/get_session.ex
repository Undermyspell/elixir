defmodule Voting.UseCases.GetSession do
  alias Voting.Models.Question
  alias Voting.Repositories.Redis

  @spec get_session() ::
          {:ok, [Question.t()]} | {:error} | {:question_session_not_running, String.t()}
  def get_session() do
    conn = Redis.get_connection()

    if not Redis.isRunning(conn) do
      {:question_session_not_running, "no questions session currently running"}
    else
      Redis.getQuestions(conn)
    end
  end
end
