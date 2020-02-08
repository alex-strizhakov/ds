defmodule DSTest do
  use DS.UACase, async: true

  test "parse/1 desktop ua" do
    ua =
      "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3315.4 Safari/537.36"

    assert DS.parse(ua) == %DS{
             bot_name: nil,
             browser: "Chrome",
             browser_version: "65.0.3315.4",
             device_brand: "unknown",
             device_model: "unknown",
             device_type: "desktop",
             is_bot?: false,
             is_mobile?: false,
             os: "Windows",
             os_version: "10"
           }
  end
end
