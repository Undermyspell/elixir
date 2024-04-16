defmodule VotingWeb.QuestionController do
  use VotingWeb, :controller

  alias Voting.VotingSession
  alias Voting.VotingSession.Question

  action_fallback(VotingWeb.FallbackController)

  def helloworld(conn, params) do
    IO.inspect(params)
    json(conn, %{Hello: "World"})
  end

  def token(conn, _params) do
    extra_claims = %{"user_id" => "some_id", "aud" => "myaudy"}

    token_with_default_plus_custom_claims =
      Voting.Shared.Auth.Token.generate_and_sign!(extra_claims, :hs256)

    signer = Joken.Signer.create("HS256", "abcdefg")

    token_with_default_plus_custom_claims2 =
      Voting.Shared.Auth.Token.generate_and_sign!(extra_claims, signer)

    json(conn, %{
      Token: token_with_default_plus_custom_claims,
      Token2: token_with_default_plus_custom_claims2
    })
  end

  def index(conn, _params) do
    questions = VotingSession.list_questions()
    render(conn, :index, questions: questions)
  end

  def create(conn, %{"question" => question_params}) do
    with {:ok, %Question{} = question} <- VotingSession.create_question(question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/questions/#{question}")
      |> render(:show, question: question)
    end
  end

  def show(conn, %{"id" => id}) do
    question =
      try do
        VotingSession.get_question!(id)
      rescue
        _ -> {:error}
      end

    render(conn, :show, question: question)
  end

  def update(conn, %{"id" => id, "question" => question_params}) do
    IO.inspect(question_params)
    IO.inspect(id)
    json(conn, %{Updated: "Question"})

    # question = VotingSession.get_question!(id)

    # with {:ok, %Question{} = question} <- VotingSession.update_question(question, question_params) do
    #   render(conn, :show, question: question)
    # end
  end

  def delete(conn, %{"id" => id}) do
    try do
      question = VotingSession.get_question!(id)
      VotingSession.delete_question(question)
      send_resp(conn, :no_content, "")
    rescue
      _ -> IO.puts("error")
    end

    # with {:ok, %Question{}} <- VotingSession.delete_question(question) do
    #   send_resp(conn, :no_content, "")
    # end
  end
end
