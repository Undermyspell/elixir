defmodule VotingWeb.QuestionController do
  require Logger
  alias Voting.UseCases
  use VotingWeb, :controller

  action_fallback(VotingWeb.FallbackController)

  def helloworld(conn, params) do
    IO.inspect(params)

    claims = Map.get(conn, :assigns) |> Map.get(:current_user_claims)
    # claims = get_session(conn, :current_user_claims)
    Logger.info(claims)
    json(conn, %{Hello: "World"})
  end

  def token(conn, _params) do
    extra_claims = %{"user_id" => "some_id", "aud" => "myaudy"}

    token_with_default_plus_custom_claims =
      Voting.Shared.Auth.Token.generate_and_sign!(extra_claims, :hs256)

    signer = Joken.Signer.create("HS256", "abcdefg")

    token_with_default_plus_custom_claims2 =
      Voting.Shared.Auth.Token.generate_and_sign!(extra_claims, signer)

    # json(conn, %{
    #   Token: token_with_default_plus_custom_claims,
    #   Token2: token_with_default_plus_custom_claims2
    # })

    render(conn, :token, %{
      Token: token_with_default_plus_custom_claims,
      Token2: token_with_default_plus_custom_claims2
    })
  end

  def start_session(conn, _params) do
    case UseCases.StartSession.start_session() do
      {:ok} ->
        conn
        |> send_resp(201, "")

      {:error} ->
        conn
        |> send_resp(500, "")
    end
  end

  def new_question(conn, %{"text" => text, "anonymous" => anonymous}) do
    newQuestion = %Voting.DTO.NewQuestion{anonymous: anonymous, text: text}

    if UseCases.CreateQuestion.create_question(newQuestion) == {:ok} do
      send_resp(conn, 200, "")
    else
      send_resp(conn, 500, "")
    end
  end

  def new_question(conn, _params) do
    send_resp(conn, 400, "This is not a valid question")
  end

  def get_session(conn, _params) do
    case UseCases.GetSession.get_session() do
      {:ok, questions} -> render(conn, :questions, questions: questions)
      {:error} -> send_resp(conn, 500, "")
    end
  end

  # def index(conn, _params) do
  #   questions = VotingSession.list_questions()
  #   render(conn, :index, questions: questions)
  # end

  # def create(conn, %{"question" => question_params}) do
  #   with {:ok, %Question{} = question} <- VotingSession.create_question(question_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", ~p"/api/questions/#{question}")
  #     |> render(:show, question: question)
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   question =
  #     try do
  #       VotingSession.get_question!(id)
  #     rescue
  #       _ -> {:error}
  #     end

  #   render(conn, :show, question: question)
  # end

  # def update(conn, %{"id" => id, "question" => question_params}) do
  #   IO.inspect(question_params)
  #   IO.inspect(id)
  #   json(conn, %{Updated: "Question"})

  #   # question = VotingSession.get_question!(id)

  #   # with {:ok, %Question{} = question} <- VotingSession.update_question(question, question_params) do
  #   #   render(conn, :show, question: question)
  #   # end
  # end

  # def delete(conn, %{"id" => id}) do
  #   try do
  #     question = VotingSession.get_question!(id)
  #     VotingSession.delete_question(question)
  #     send_resp(conn, :no_content, "")
  #   rescue
  #     _ -> IO.puts("error")
  #   end

  #   # with {:ok, %Question{}} <- VotingSession.delete_question(question) do
  #   #   send_resp(conn, :no_content, "")
  #   # end
  # end
end
