defmodule Voting.DTO.NewQuestion do
  @derive Jason.Encoder
  defstruct text: nil,
            anonymous: nil

  @type t :: %__MODULE__{
          text: String.t(),
          anonymous: boolean()
        }
end
