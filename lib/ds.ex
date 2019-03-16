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
          browser: String.t() | nil,
          browser_version: String.t() | nil,
          os: String.t() | nil,
          os_version: String.t() | nil,
          device_type: String.t() | nil,
          device_brand: String.t() | nil,
          device_model: String.t() | nil,
          # browser_id: integer,
          # browser_version_id: integer,
          # os_id: integer,
          # os_version_id: integer,
          # device_type_id: integer,
          # device_brand_id: integer,
          # device_model_id: integer,
          mobile?: boolean,
          bot?: boolean,
          bot_name: String.t() | nil
        }

  defstruct browser: nil,
            browser_version: nil,
            os: nil,
            os_version: nil,
            device_type: nil,
            device_brand: nil,
            device_model: nil,
            bot_name: nil,
            # browser_id: 0,
            # browser_version_id: 0,
            # os_id: 0,
            # os_version_id: 0,
            # device_type_id: 0,
            # device_brand_id: 0,
            # device_model_id: 0,
            mobile?: false,
            bot?: false

  @doc """
  Parses user agent.
  """
  @spec parse(ua) :: t
  defdelegate parse(ua), to: Parser
end
