defmodule Voting.VotingSessionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Voting.VotingSession` context.
  """

  @doc """
  Generate a question.
  """
  def question_fixture(attrs \\ %{}) do
    {:ok, question} =
      attrs
      |> Enum.into(%{
        anonymous: true,
        answered: true,
        creatorHash: "some creatorHash",
        creatorName: "some creatorName",
        id: "some id",
        text: "some text",
        voted: true,
        votes: 42
      })
      |> Voting.VotingSession.create_question()

    question
  end
end
