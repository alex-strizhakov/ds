defmodule DS.Parser do
  @moduledoc """
  Parser module, which looks for cached value. If is not found, parses user agent by UAInspector (https://github.com/elixytics/ua_inspector)
  """

  @type found :: {:ok, DS.t()}
  @type not_found :: {:error, DS.ua()}
  @type map_with_result :: %{ds: DS.t(), result: %UAInspector.Result{}}

  @mobile_device_types ["smartphone", "tablet", "phablet", "feature phone"]

  @doc """
  Parses user agent
  """
  @spec parse(DS.ua()) :: DS.t() | nil
  def parse(""), do: nil
  def parse(nil), do: nil

  def parse(ua) do
    ua
    |> check_cache()
    |> do_parse()
  end

  @spec check_cache(DS.ua()) :: found | not_found
  def check_cache(ua) do
    case lookup_cache(generate_key(ua)) do
      [] -> {:error, ua}
      [{_key, json}] -> {:ok, struct(DS, Jason.decode!(json, keys: :atoms!))}
    end
  end

  @spec do_parse(found | not_found) :: DS.t()
  defp do_parse({:ok, ds}), do: ds

  defp do_parse({:error, ua}) do
    ds =
      UAInspector.parse(ua)
      |> assemble_client()
      |> assemble_device()
      |> assemble_os

    with key <- generate_key(ua),
         json <- Jason.encode!(ds) do
      write_cache(key, json)
    end

    ds
  end

  @spec assemble_client(%UAInspector.Result{} | %UAInspector.Result.Bot{}) ::
          map_with_result | DS.t()
  defp assemble_client(%{client: :unknown}) do
    %DS{
      device_type: "desktop"
    }
  end

  # TODO: make PULL request for documentation fix, return Result OR Bot
  defp assemble_client(%UAInspector.Result.Bot{name: name}) do
    %DS{
      is_bot?: true,
      bot_name: name
    }
  end

  defp assemble_client(%{client: client} = result) do
    ds = %DS{
      browser: client.name,
      browser_version: client.version
    }

    Map.new(ds: ds, result: result)
  end

  @spec assemble_device(map_with_result | %DS{}) :: map_with_result | DS.t()
  defp assemble_device(%DS{} = ds), do: ds

  defp assemble_device(%{ds: ds, result: %{device: device} = result}) do
    %{
      ds: %{
        ds
        | device_type: to_string(device.type),
          device_brand: to_string(device.brand),
          device_model: to_string(device.model),
          is_mobile?: device.type in @mobile_device_types
      },
      result: result
    }
  end

  @spec assemble_os(map_with_result | %DS{}) :: map_with_result | DS.t()
  defp assemble_os(%DS{} = ds), do: ds

  defp assemble_os(%{ds: ds, result: %{os: os}}) do
    %{ds | os: os.name, os_version: to_string(os.version)}
  end

  @spec generate_key(DS.ua()) :: String.t()
  defp generate_key(ua) do
    Base.encode16(:crypto.hash(:md5, ua), case: :lower)
  end

  @spec lookup_cache(String.t()) :: [] | [tuple()]
  defp lookup_cache(key) do
    :ets.lookup(Application.get_env(:ds, :table_name), key)
  end

  @spec write_cache(String.t(), String.t()) :: boolean()
  defp write_cache(key, value) do
    true = :ets.insert(Application.get_env(:ds, :table_name), {key, value})
  end
end
