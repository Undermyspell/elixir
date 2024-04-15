defmodule VotingWeb.QuestionControllerTest do
  use VotingWeb.ConnCase

  import Voting.VotingSessionFixtures

  alias Voting.VotingSession.Question

  @create_attrs %{
    anonymous: true,
    answered: true,
    creatorHash: "some creatorHash",
    creatorName: "some creatorName",
    id: "some id",
    text: "some text",
    voted: true,
    votes: 42
  }
  @update_attrs %{
    anonymous: false,
    answered: false,
    creatorHash: "some updated creatorHash",
    creatorName: "some updated creatorName",
    id: "some updated id",
    text: "some updated text",
    voted: false,
    votes: 43
  }
  @invalid_attrs %{anonymous: nil, answered: nil, creatorHash: nil, creatorName: nil, id: nil, text: nil, voted: nil, votes: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all questions", %{conn: conn} do
      conn = get(conn, ~p"/api/questions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create question" do
    test "renders question when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/questions", question: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/questions/#{id}")

      assert %{
               "id" => ^id,
               "anonymous" => true,
               "answered" => true,
               "creatorHash" => "some creatorHash",
               "creatorName" => "some creatorName",
               "id" => "some id",
               "text" => "some text",
               "voted" => true,
               "votes" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/questions", question: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update question" do
    setup [:create_question]

    test "renders question when data is valid", %{conn: conn, question: %Question{id: id} = question} do
      conn = put(conn, ~p"/api/questions/#{question}", question: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/questions/#{id}")

      assert %{
               "id" => ^id,
               "anonymous" => false,
               "answered" => false,
               "creatorHash" => "some updated creatorHash",
               "creatorName" => "some updated creatorName",
               "id" => "some updated id",
               "text" => "some updated text",
               "voted" => false,
               "votes" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, question: question} do
      conn = put(conn, ~p"/api/questions/#{question}", question: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete question" do
    setup [:create_question]

    test "deletes chosen question", %{conn: conn, question: question} do
      conn = delete(conn, ~p"/api/questions/#{question}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/questions/#{question}")
      end
    end
  end

  defp create_question(_) do
    question = question_fixture()
    %{question: question}
  end
end
