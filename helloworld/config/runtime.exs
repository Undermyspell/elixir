import Config

config :voting, :config, %{
  redisEndpoint: "redis_endpoint",
  redisPassword: System.get_env("REDIS_PASSWORD")
}
