defmodule DSPlugTest do
  use DS.UACase, async: true
  use Plug.Test
  alias DSPlug

  @opts DSPlug.init([])

  test "return device info in connection" do
    ua =
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.3 Safari/605.1.15"

    conn =
      conn(:get, "/")
      |> put_req_header(
        "user-agent",
        ua
      )

    conn = DSPlug.call(conn, @opts)

    assert conn.assigns[:device_info] == %DS{
             bot_name: nil,
             browser: "Safari",
             browser_version: "12.0.3",
             device_brand: "Apple",
             device_model: "unknown",
             device_type: "desktop",
             is_bot?: false,
             is_mobile?: false,
             os: "Mac",
             os_version: "10.14.3"
           }
  end
end
