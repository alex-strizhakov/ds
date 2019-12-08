defmodule DS.ParserTest do
  use DS.UACase, async: true
  alias DS.Parser

  test "parse/1 for web client" do
    ua =
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.3 Safari/605.1.15"

    assert Parser.parse(ua) == %DS{
             is_bot?: false,
             bot_name: nil,
             browser: "Safari",
             browser_version: "12.0.3",
             device_brand: "Apple",
             device_model: "unknown",
             device_type: "desktop",
             is_mobile?: false,
             os: "Mac",
             os_version: "10.14.3"
           }
  end

  test "parse/1 for mobile client" do
    ua =
      "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1"

    assert Parser.parse(ua) == %DS{
             is_bot?: false,
             bot_name: nil,
             browser: "Mobile Safari",
             browser_version: "12.0",
             device_brand: "Apple",
             device_model: "iPhone",
             device_type: "smartphone",
             is_mobile?: true,
             os: "iOS",
             os_version: "12.1.4"
           }
  end

  test "parse/1 for tablet client" do
    ua =
      "Mozilla/5.0 (iPad; CPU OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B554a Safari/9537.53"

    assert Parser.parse(ua) == %DS{
             is_bot?: false,
             bot_name: nil,
             browser: "Mobile Safari",
             browser_version: "7.0",
             device_brand: "Apple",
             device_model: "iPad",
             device_type: "tablet",
             is_mobile?: true,
             os: "iOS",
             os_version: "7.0.4"
           }
  end

  test "parse/1 for bot" do
    ua =
      "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Safari/537.36"

    assert Parser.parse(ua) == %DS{
             is_bot?: true,
             bot_name: "Googlebot",
             browser: nil,
             browser_version: nil,
             device_brand: nil,
             device_model: nil,
             device_type: nil,
             is_mobile?: false,
             os: nil,
             os_version: nil
           }
  end

  test "parse/1 for generic grawler bot" do
    ua = "generic crawler agent"

    assert Parser.parse(ua) == %DS{
             is_bot?: true,
             bot_name: "Generic Bot",
             browser: nil,
             browser_version: nil,
             device_brand: nil,
             device_model: nil,
             device_type: nil,
             is_mobile?: false,
             os: nil,
             os_version: nil
           }
  end

  test "parse/1 for undefined client" do
    ua = "--- undetectable ---"

    assert Parser.parse(ua) == %DS{
             is_bot?: false,
             bot_name: nil,
             browser: nil,
             browser_version: nil,
             device_brand: nil,
             device_model: nil,
             device_type: "desktop",
             is_mobile?: false,
             os: nil,
             os_version: nil
           }
  end

  test "empty string or nil returns nil" do
    assert is_nil(Parser.parse(""))
    assert is_nil(Parser.parse(nil))
  end
end
