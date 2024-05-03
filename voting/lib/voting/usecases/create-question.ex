defmodule Voting.UseCases.CreateQuestion do
  require Logger
  alias Voting.Repositories.Redis

  @spec create_question(Voting.DTO.NewQuestion.t()) :: {:error} | {:ok}
  def create_question(%Voting.DTO.NewQuestion{} = newQuestion) do
    case Redis.get_connection() |> Redis.addQuestion(newQuestion.text, newQuestion.anonymous, "test1", "test2") do
      {:ok, _} ->
        {:ok}

      {:error, err} ->
        Logger.error(err)
        {:error}
    end
  end
end
