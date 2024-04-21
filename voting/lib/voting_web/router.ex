defmodule VotingWeb.Router do
  use VotingWeb, :router
  @dialyzer {:nowarn_function, verify_token: 1}

  pipeline :auth do
    plug(:require_auth)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", VotingWeb do
    pipe_through([:api, :auth])

    resources("/questions", QuestionController, except: [:new, :edit])

    get("/helloworld", QuestionController, :helloworld)
    post("/start", QuestionController, :start_session)
  end

  scope "/api/token", VotingWeb do
    pipe_through(:api)

    get("/", QuestionController, :token)
  end

  def require_auth(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- verify_token(token) do
      assign(conn, :current_user_claims, claims)
    else
      _ ->
        conn
        |> send_resp(:unauthorized, "No access for you")
        |> halt()
    end
  end

  defp verify_token(token) do
    if Mix.env() !== :test do
      Voting.Shared.Auth.Token.verify_and_validate(token)
    else
      config = Joken.Signer.parse_config(:hs256)
      Joken.Signer.verify(token, config)
    end
  end
end
