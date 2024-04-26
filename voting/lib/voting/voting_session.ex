defmodule Voting.VotingSession do
  #   @moduledoc """
  #   The VotingSession context.
  #   """

  #   alias Voting.Repo

  # alias Voting.VotingSession.Question
  require Logger
  alias Voting.Models.Question
  alias Voting.Repositories.Redis

  #   @doc """
  #   Returns the list of questions.

  #   ## Examples

  #       iex> list_questions()
  #       [%Question{}, ...]

  #   """
  #   def list_questions do
  #     "asd"
  #   end

  #   @doc """
  #   Gets a single question.

  #   Raises if the Question does not exist.

  #   ## Examples

  #       iex> get_question!(123)
  #       %Question{}

  #   """
  @spec start_session() :: {:error} | {:ok}
  def start_session() do
    Redis.get_connection() |> Redis.start_session()
  end

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

  @spec get_session() :: {:ok, [Question.t()]} | {:error}
  def get_session() do
    Redis.get_connection() |> Redis.getQuestions()
  end

  #   @doc """
  #   Creates a question.

  #   ## Examples

  #       iex> create_question(%{field: value})
  #       {:ok, %Question{}}

  #       iex> create_question(%{field: bad_value})
  #       {:error, ...}

  #   """
  #   def create_question(attrs \\ %{}) do
  #     attrs
  #   end

  #   @doc """
  #   Updates a question.

  #   ## Examples

  #       iex> update_question(question, %{field: new_value})
  #       {:ok, %Question{}}

  #       iex> update_question(question, %{field: bad_value})
  #       {:error, ...}

  #   """
  #   def update_question(%Question{} = question, attrs) do
  #     raise "TODO"
  #   end

  #   @doc """
  #   Deletes a Question.

  #   ## Examples

  #       iex> delete_question(question)
  #       {:ok, %Question{}}

  #       iex> delete_question(question)
  #       {:error, ...}

  #   """
  #   def delete_question(%Question{} = question) do
  #     raise "TODO"
  #   end

  #   @doc """
  #   Returns a data structure for tracking question changes.

  #   ## Examples

  #       iex> change_question(question)
  #       %Todo{...}

  #   """
  #   def change_question(%Question{} = question, _attrs \\ %{}) do
  #     raise "TODO"
  #   end
end
