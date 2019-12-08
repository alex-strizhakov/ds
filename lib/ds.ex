defmodule DS do
  @moduledoc """
  Device Structure module.

  This module defines a `DS` struct and the main functions for working with devices.
  """
  alias DS.Parser

  @typedoc """
  UA - user agent.
  """
  @type ua :: String.t() | nil
  @type t :: %__MODULE__{
          browser: String.t(),
          browser_version: String.t(),
          os: String.t(),
          os_version: String.t(),
          device_type: String.t(),
          device_brand: String.t(),
          device_model: String.t(),
          is_mobile?: boolean(),
          is_bot?: boolean(),
          bot_name: String.t()
        }

  @derive Jason.Encoder
  defstruct browser: nil,
            browser_version: nil,
            os: nil,
            os_version: nil,
            device_type: nil,
            device_brand: nil,
            device_model: nil,
            bot_name: nil,
            is_mobile?: false,
            is_bot?: false

  @doc """
  Parses user agent.
  """
  @spec parse(ua) :: t() | nil
  defdelegate parse(ua), to: Parser
end
