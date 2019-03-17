defmodule DS.UACase do
  use ExUnit.CaseTemplate

  setup_all do
    # Wait until UAInspector loads all DBs.
    wait_for(fn -> UAInspector.ready?() end)
    :ok
  end

  @spec wait_for(function()) :: true
  def wait_for(func) do
    :timer.sleep(100)

    case func.() do
      true -> true
      false -> wait_for(func)
    end
  end
end
