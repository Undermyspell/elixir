defmodule Voting.Repositories.RedisQuestion do
  alias Voting.Repositories.RedisQuestion

  @derive Jason.Encoder
  defstruct id: nil,
            text: nil,
            votes: nil,
            answered: nil,
            creatorHash: nil,
            creatorName: nil,
            anonymous: nil

  @type t :: %__MODULE__{
          id: integer(),
          text: String.t(),
          votes: integer(),
          answered: boolean(),
          creatorHash: String.t(),
          creatorName: String.t(),
          anonymous: boolean()
        }

  @spec new(String.t(), String.t(), String.t(), boolean()) :: %RedisQuestion{}
  def new(text, creatorName, creatorHash, anonymous) do
    %RedisQuestion{
      id: Ecto.ULID.generate(),
      text: text,
      votes: 0,
      answered: false,
      creatorHash: creatorHash,
      creatorName: creatorName,
      anonymous: anonymous
    }
  end

  def new(
        %{
          "id" => _,
          "text" => _,
          "votes" => _,
          "answered" => _,
          "creatorHash" => _,
          "creatorName" => _,
          "anonymous" => _
        } = raw
      ) do
    newQ =
      raw
      |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
      |> Map.new()

    struct(RedisQuestion, newQ)
  end
end
