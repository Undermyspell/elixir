# defmodule Voting.VotingSessionTest do
#   use Voting.DataCase

#   alias Voting.VotingSession

#   describe "questions" do
#     alias Voting.VotingSession.Question

#     import Voting.VotingSessionFixtures

#     @invalid_attrs %{anonymous: nil, answered: nil, creatorHash: nil, creatorName: nil, id: nil, text: nil, voted: nil, votes: nil}

#     test "list_questions/0 returns all questions" do
#       question = question_fixture()
#       assert VotingSession.list_questions() == [question]
#     end

#     test "get_question!/1 returns the question with given id" do
#       question = question_fixture()
#       assert VotingSession.get_question!(question.id) == question
#     end

#     test "create_question/1 with valid data creates a question" do
#       valid_attrs = %{anonymous: true, answered: true, creatorHash: "some creatorHash", creatorName: "some creatorName", id: "some id", text: "some text", voted: true, votes: 42}

#       assert {:ok, %Question{} = question} = VotingSession.create_question(valid_attrs)
#       assert question.anonymous == true
#       assert question.answered == true
#       assert question.creatorHash == "some creatorHash"
#       assert question.creatorName == "some creatorName"
#       assert question.id == "some id"
#       assert question.text == "some text"
#       assert question.voted == true
#       assert question.votes == 42
#     end

#     test "create_question/1 with invalid data returns error changeset" do
#       assert {:error, %Ecto.Changeset{}} = VotingSession.create_question(@invalid_attrs)
#     end

#     test "update_question/2 with valid data updates the question" do
#       question = question_fixture()
#       update_attrs = %{anonymous: false, answered: false, creatorHash: "some updated creatorHash", creatorName: "some updated creatorName", id: "some updated id", text: "some updated text", voted: false, votes: 43}

#       assert {:ok, %Question{} = question} = VotingSession.update_question(question, update_attrs)
#       assert question.anonymous == false
#       assert question.answered == false
#       assert question.creatorHash == "some updated creatorHash"
#       assert question.creatorName == "some updated creatorName"
#       assert question.id == "some updated id"
#       assert question.text == "some updated text"
#       assert question.voted == false
#       assert question.votes == 43
#     end

#     test "update_question/2 with invalid data returns error changeset" do
#       question = question_fixture()
#       assert {:error, %Ecto.Changeset{}} = VotingSession.update_question(question, @invalid_attrs)
#       assert question == VotingSession.get_question!(question.id)
#     end

#     test "delete_question/1 deletes the question" do
#       question = question_fixture()
#       assert {:ok, %Question{}} = VotingSession.delete_question(question)
#       assert_raise Ecto.NoResultsError, fn -> VotingSession.get_question!(question.id) end
#     end

#     test "change_question/1 returns a question changeset" do
#       question = question_fixture()
#       assert %Ecto.Changeset{} = VotingSession.change_question(question)
#     end
#   end
# end
