defmodule DS.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    :ets.new(:ds_cache, [
      :named_table,
      :set,
      :public,
      read_concurrency: true
    ])

    children = []
    opts = [strategy: :one_for_one, name: DS.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
