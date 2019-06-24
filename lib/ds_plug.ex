defmodule DSPlug do
  @moduledoc """
  Assings device info in the connection.
  """
  import Plug.Conn

  def init(_opts), do: false

  def call(conn, _opts) do
    with [ua] <- get_req_header(conn, "user-agent") do
      assign(conn, :device_info, DS.parse(ua))
    else
      _ -> conn
    end
  end
end
