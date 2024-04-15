defmodule Voting.Shared.Auth.Token do
  # no signer
  use Joken.Config, default_signer: nil

  # This hook implements a before_verify callback that checks whether it has a signer configuration
  # cached. If it does not, it tries to fetch it from the jwks_url.
  add_hook(JokenJwks,
    strategy: Voting.Shared.Auth.KeycloakStrategy
  )

  @impl true
  def token_config do
    default_claims(skip: [:aud, :iss])
    |> add_claim("aud", nil, &Enum.member?(&1, "party-ext"))

    # |> add_claim("exp", nil, fn _ -> true end)
  end
end

defmodule Voting.Shared.Auth.KeycloakStrategy do
  use JokenJwks.DefaultStrategyTemplate

  def init_opts(opts),
    do: [
      jwks_url:
        "https://keycloak.omnect.conplement.cloud/realms/cp-prod/protocol/openid-connect/certs"
    ]
end
