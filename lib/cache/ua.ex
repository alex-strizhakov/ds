defmodule DS.Cache.UA do
  @moduledoc """
  Caching module.
  """
  use GenServer

  @type key :: String.t()
  @type json_string :: String.t()
  @type get_value :: {:get, key}
  @type set_value :: {:set, key, json_string}

  @table_name :user_agents

  # Client

  @spec start_link(GenServer.options()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      [
        {:table_name, @table_name},
        {:log_limit, 1_000_000}
      ],
      opts
    )
  end

  @doc """
  Used to keep clean state between tests.
  """
  @spec clean_up() :: boolean
  def clean_up do
    :ets.delete_all_objects(@table_name)
  end

  @spec get(key) :: json_string | nil
  def get(key) do
    case GenServer.call(__MODULE__, {:get, key}) do
      [] -> nil
      [{_key, result}] -> result
    end
  end

  @spec set(key, json_string) :: term()
  def set(key, value) do
    GenServer.call(__MODULE__, {:set, key, value})
  end

  # Server Callbacks

  @spec handle_call(get_value | set_value, term(), term()) :: term()
  def handle_call({:get, key}, _from, state) do
    with %{table_name: table_name} = state,
         result <- :ets.lookup(table_name, key) do
      {:reply, result, state}
    end
  end

  def handle_call({:set, key, value}, _from, state) do
    with %{table_name: table_name} = state,
         true <- :ets.insert(table_name, {key, value}) do
      {:reply, value, state}
    end
  end

  @spec init([tuple()]) :: term()
  def init(args) do
    [{:table_name, table_name}, {:log_limit, log_limit}] = args
    :ets.new(table_name, [:named_table, :set, :protected, read_concurrency: true])
    {:ok, %{log_limit: log_limit, table_name: table_name}}
  end
end
