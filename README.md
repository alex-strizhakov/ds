# Device Structure

This module is designed to facilitate the device structure (through `Plug.Conn.assign/3`) and easy connection to other projects.

## Installation

The module can be installed by adding `ds` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ds, "~> 1.1"}
  ]
end
```

Run mix task to download databases for `UAInspector`:

```console
$ mix ua_inspector.download
```

## Usage

Create new pipeline in your Router file:

```elixir
defmodule ExampleWeb.Router do
  use ExampleWeb.Router

  pipeline :device_detectable do
    plug DSPlug
  end

  # Add pipeline to scope
  scope "/", ExampleWeb do
    pipe_through [:browser, :device_detectable]
    get "/", ExampleController, :index
  end
end
```

Now you can access it from your controller.

```elixir
def ExampleController do
  use ExampleWeb, :controller

  def index(conn, _params) do
    IO.inspect(conn.assigns[:device_info])
    text(conn, "OK")
  end
end
```

# Example

```elixir
iex(1)> DS.parse("Mozilla/5.0 (iPad; CPU OS 7_0_4 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11B554a Safari/9537.53")
%DS{
  bot_name: nil,
  browser: "Mobile Safari",
  browser_version: "7.0",
  device_brand: "Apple",
  device_model: "iPad",
  device_type: "tablet",
  is_bot?: false,
  is_mobile?: true,
  os: "iOS",
  os_version: "7.0.4"
}
```
## Dependencies used in library

```elixir
defp deps do
  [
    {:plug_cowboy, "~> 2.1"},
    {:ua_inspector, "~> 1.0"},
    {:jason, "~> 1.1"}
  ]
end
```

- https://github.com/elixir-plug/plug_cowboy
- https://github.com/elixytics/ua_inspector
- https://github.com/michalmuskala/jason

## License

This project is licensed under the terms of the MIT license.
