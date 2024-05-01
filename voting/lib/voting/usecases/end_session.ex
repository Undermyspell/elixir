defmodule Voting.UseCases.EndSession do
  #   @moduledoc """
  #   The VotingSession context.
  #   """

  #   alias Voting.Repo

  # alias Voting.VotingSession.Question
  require Logger
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
  @spec end_session() :: {:error} | {:ok}
  def end_session() do
    Redis.get_connection() |> Redis.end_session()
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
