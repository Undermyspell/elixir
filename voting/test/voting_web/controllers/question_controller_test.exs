defmodule VotingWeb.QuestionControllerTest do
  use VotingWeb.ConnCase, async: true

  import Voting.VotingSessionFixtures

  require Logger
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
  @invalid_attrs %{
    anonymous: nil,
    answered: nil,
    creatorHash: nil,
    creatorName: nil,
    id: nil,
    text: nil,
    voted: nil,
    votes: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "helloworld" do
    # setup [:get_user_token]

    test "200 succes with hello world text", %{conn: conn} do
      # %{token: token} = get_user_token(123)

      tasks =
        1..5
        |> Enum.map(&get_user_token(&1))
        |> Enum.map(&Task.async(fn -> sendRequest(conn, &1.token) end))

      # tasks = [
      #   Task.async(fn -> sendr(conn, token) end),
      #   Task.async(fn -> sendr(conn, token) end)
      # ]

      # c = conn
      # c = put_req_header(c, "authorization", "Bearer #{token}")
      # c = get(c, ~p"/api/helloworld")

      res = Task.await_many(tasks)

      Enum.each(res, &(json_response(&1, 200) |> Logger.info()))

      # assert json_response(c, 200) == %{"Hello" => "World"}
      assert Enum.all?(res, &(json_response(&1, 200) == %{"Hello" => "World"}))
    end
  end

  describe "start_session" do
    # setup [:get_user_token]

    # test "200 succes with hello world text", %{conn: conn, token: token} do
    test "201 sucess started session", %{conn: conn} do
      %{token: token} = get_user_token(1)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post(~p"/api/start")

      assert response(conn, 201) == ""
    end
  end

  defp sendRequest(conn, token) do
    conn
    |> put_req_header("authorization", "Bearer #{token}")
    |> get(~p"/api/helloworld")
  end

  # describe "create question" do
  #   test "renders question when data is valid", %{conn: conn} do
  #     conn = post(conn, ~p"/api/questions", question: @create_attrs)
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get(conn, ~p"/api/questions/#{id}")

  #     assert %{
  #              "id" => ^id,
  #              "anonymous" => true,
  #              "answered" => true,
  #              "creatorHash" => "some creatorHash",
  #              "creatorName" => "some creatorName",
  #              "id" => "some id",
  #              "text" => "some text",
  #              "voted" => true,
  #              "votes" => 42
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post(conn, ~p"/api/questions", question: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update question" do
  #   setup [:create_question]

  #   test "renders question when data is valid", %{
  #     conn: conn,
  #     question: %Question{id: id} = question
  #   } do
  #     conn = put(conn, ~p"/api/questions/#{question}", question: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, ~p"/api/questions/#{id}")

  #     assert %{
  #              "id" => ^id,
  #              "anonymous" => false,
  #              "answered" => false,
  #              "creatorHash" => "some updated creatorHash",
  #              "creatorName" => "some updated creatorName",
  #              "id" => "some updated id",
  #              "text" => "some updated text",
  #              "voted" => false,
  #              "votes" => 43
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, question: question} do
  #     conn = put(conn, ~p"/api/questions/#{question}", question: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete question" do
  #   setup [:create_question]

  #   test "deletes chosen question", %{conn: conn, question: question} do
  #     conn = delete(conn, ~p"/api/questions/#{question}")
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, ~p"/api/questions/#{question}")
  #     end
  #   end
  # end

  # defp create_question(_) do
  #   question = question_fixture()
  #   %{question: question}
  # end

  defp get_user_token() do
    get_user_token(1)
  end

  defp get_user_token(id) do
    IO.puts(id)
    extra_claims = %{"user_id" => "tester_" <> Integer.to_string(id), "aud" => "testaud"}

    token = Voting.Shared.Auth.Token.generate_and_sign!(extra_claims, :hs256)
    %{token: token}
  end
end
