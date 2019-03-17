# DeviceStructure

This module is designed to facilitate the Device structure (Plug.Conn.assign) and easy connection to other projects.

## Installation

The module can be installed by adding `ds` to your list of dependencies in `mix.exs` with git url:

```elixir
def deps do
  [
    {:ds, git: "https://github.com/alex-strizhakov/ds"}
  ]
end
```

Run mix task for download UAInspector databases:

```console
$ mix ua_inspector.download
```

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
