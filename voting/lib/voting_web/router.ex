defmodule VotingWeb.Router do
  use VotingWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:require_auth)
  end

  scope "/api", VotingWeb do
    pipe_through(:api)

    resources("/questions", QuestionController, except: [:new, :edit])

    get("/helloworld", QuestionController, :helloworld)
  end

  def require_auth(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Voting.Shared.Auth.Token.verify_and_validate(token) do
      IO.puts(token)
      assign(conn, :current_user_claims, claims)
    else
      _ ->
        conn
        |> send_resp(:unauthorized, "No access for you")
        |> halt()
    end
  end
end
